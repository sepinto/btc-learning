function wkday = unix2weekday( unix )
% UNIX2WEEKDAY converts a unix epoch time value (seconds since Jan. 1, 1970)
%   into a day of week
wkday = weekday(datestr(datenum(double(unix)/86400) + datenum(1970,1,1)));
end

