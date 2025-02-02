var
    isEmpty = value =>
        value.toString().trim().length === 0
    ,
    isEmail = value =>
        /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/.test(value)
    ,
    isDate = value => {

        // First check for the pattern
        if(!/^\d{1,2}\/\d{1,2}\/\d{4}$/.test(value))
            return false;

        // Parse the date parts to integers
        var day = parseInt(value.substring(0, 2), 10),
            month = parseInt(value.substring(3, 5), 10),
            year = parseInt(value.substring(6), 10);

        // Check the ranges of month and year
        if(year < 1000 || year > 3000 || month === 0 || month > 12)
            return false;

        var monthLength = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];

        // Adjust for leap years
        if(year % 400 === 0 || (year % 100 !== 0 && year % 4 === 0))
            monthLength[1] = 29;

        // Check the range of the day
        return day > 0 && day <= monthLength[month - 1];
    }
;