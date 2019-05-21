//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package org.elasticsearch.xpack.core;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.jar.JarInputStream;
import java.util.jar.Manifest;
import org.elasticsearch.common.SuppressForbidden;
import org.elasticsearch.common.io.PathUtils;

public class XPackBuild {
    public static final XPackBuild CURRENT;
    private String shortHash;
    private String date;

    @SuppressForbidden(
            reason = "looks up path of xpack.jar directly"
    )
    static Path getElasticsearchCodebase() {
        URL url = XPackBuild.class.getProtectionDomain().getCodeSource().getLocation();

        try {
            return PathUtils.get(url.toURI());
        } catch (URISyntaxException var2) {
            throw new RuntimeException(var2);
        }
    }

    XPackBuild(String shortHash, String date) {
        this.shortHash = shortHash;
        this.date = date;
    }

    public String shortHash() {
        return this.shortHash;
    }

    public String date() {
        return this.date;
    }

    static {
        Path path = getElasticsearchCodebase();
        String shortHash;
        String date;
        shortHash = "Unknown";
        date = "Unknown";

        CURRENT = new XPackBuild(shortHash, date);
    }
}
