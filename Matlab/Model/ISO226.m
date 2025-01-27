classdef ISO226 < handle
    %LoudnessContours Provide and manipulate loudness contour data
    
    properties
        contourSet
        f
        af
        Lu
        Tf
        Lp
        Ln
        currentSplLevel
        currentPhonLevel
    end
    
    methods (Static)
        function obj = ISO226()
            %Parameters of equal-loudness contours
            obj.f = [20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 8000 10000 12500];
            obj.af = [0.532 0.506 0.480 0.455 0.432 0.409 0.387 0.367 0.349 0.330 0.315 0.301 0.288 0.276 0.267 0.259 0.253 0.250 0.246 0.244 0.243 0.243 0.243 0.242 0.242 0.245 0.254 0.271 0.301];
            obj.Lu = [-31.6 -27.2 -23.0 -19.1 -15.9 -13.0 -10.3 -8.1 -6.2 -4.5 -3.1  -2.0  -1.1  -0.4  0.0  0.3  0.5  0.0 -2.7 -4.1 -1.0  1.7  2.5  1.2  -2.1  -7.1 -11.2 -10.7  -3.1];
            obj.Tf = [ 78.5  68.7  59.5  51.1  44.0  37.5  31.5  26.5  22.1  17.9  14.4  11.4  8.6  6.2  4.4  3.0  2.2  2.4  3.5  1.7  -1.3  -4.2  -6.0  -5.4  -1.5  6.0  12.6  13.9  12.3];
            obj.currentPhonLevel = 0;
            obj.setPhonLevel(10);
            obj.currentSplLevel = 0;
            obj.setSplLevel(10);
        end
    end
    
    methods
        function [SPLf] = getSPL(self, phon, frequency)
            % Update phon table if necessary
            if phon ~= self.currentPhonLevel
                self.setPhonLevel(phon);
            end
            
            % Interpolate for specific frequency point
            SPLf = interp1(self.f, self.Lp, frequency, 'linear', 'extrap');
        end
        
        function [PHONf] = getPhon(self, SPL, frequency)
            % Update phon table if necessary
            if SPL ~= self.currentSplLevel
                self.setSplLevel(SPL);
            end

            % Interpolate for specific frequency point
            PHONf = interp1(self.f, self.Ln, frequency, 'linear', 'extrap');
        end
        
        function [] = setPhonLevel(self, phon)
            % Get table for given phon value
            Af = (0.4*10.^(((self.Tf+self.Lu)/10)-9)).^self.af + (4.47E-3 * (10.^(0.025*phon)-1.15));
            self.Lp = ((10./self.af).*log10(Af))-self.Lu+94;
            self.currentPhonLevel = phon;
        end
        
        function [] = setSplLevel(self, spl)
            % Get table for given phon value
            Bf = (0.4*(10.^((spl+self.Lu)./10-9))).^self.af-(0.4*(10.^((self.Tf+self.Lu)./10-9))).^self.af+0.005135;
            self.Ln = (40*log10(Bf))+94;
            self.currentSplLevel = spl;
        end
    end
end