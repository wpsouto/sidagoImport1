package com.mycompany.myapp.service.util;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Utility class for generating random Strings.
 */
public final class CoordinateUtil {

    private final Logger log = LoggerFactory.getLogger(CoordinateUtil.class);

    public static LatLng parseLatLng(final Integer latitude, final Integer longitude) {
        return parseLatLng(String.valueOf(latitude), String.valueOf(longitude));
    }

    private static LatLng parseLatLng(final String latitude, final String longitude) {

        if (StringUtils.isBlank(latitude) || StringUtils.isBlank(longitude)) {
            return new LatLng();
        }

        Double lat = NumberParser.parseDouble(latitude);
        Double lng = NumberParser.parseDouble(longitude);

        try {
            lat = parseDMS(lat);
            lng = parseDMS(lng);
        } catch (IllegalArgumentException e) {
            return new LatLng();
        }

        return new LatLng(lat, lng);
    }

    private static double dmsToDecimal(Double degree, Double minutes, Double seconds) {
        degree = degree == null ? 0 : degree;
        minutes = minutes == null ? 0 : minutes;
        seconds = seconds == null ? 0 : seconds;
        return -1 * (degree + (minutes / 60) + (seconds / 3600));
    }

    private static double parseDMS(Double coordenade) {
        String coord = String.valueOf(coordenade);

        if (coord.length() >= 6) {
            String degree = coord.substring(0, 2);
            String minutes = coord.substring(2, 4);
            String seconds = coord.substring(4, coord.length() - 1);

            if (NumberParser.parseDouble(degree) <= 90) {
                return roundTo6decimals(dmsToDecimal(NumberParser.parseDouble(degree), NumberParser.parseDouble(minutes), NumberParser.parseDouble(seconds)));
            }
        }

        throw new IllegalArgumentException();
    }

    private static Double roundTo6decimals(Double x) {
        return x == null ? null : Math.round(x * Math.pow(10, 6)) / Math.pow(10, 6);
    }

    public static void main(String[] args) {
        String latitude = ("0");
        String longitude = ("4614556");

        LatLng latLng = CoordinateUtil.parseLatLng(123456, null);
        System.out.printf(latLng.toString());
    }

}
