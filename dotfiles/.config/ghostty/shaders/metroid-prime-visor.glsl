void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec4 c = texture(iChannel0, uv);

    float brightness = max(max(c.r, c.g), c.b);

    float scanA = sin(fragCoord.y * 0.68 + iTime * 0.55) * 0.0018;
    float scanB = sin(fragCoord.y * 1.55 - iTime * 0.32) * 0.0010;
    c.rgb -= scanA + scanB;

    float lineMask = step(0.998, fract(fragCoord.y * 0.14));
    c.rgb *= mix(1.0, 0.995, lineMask);

    float sweep = fract(uv.y * 0.55 - iTime * 0.018);
    float band = smoothstep(0.00, 0.045, sweep) * (1.0 - smoothstep(0.045, 0.10, sweep));
    c.rgb += vec3(0.00, 0.004, 0.005) * band;

    c.rgb += vec3(0.00, 0.010, 0.012) * brightness * 0.018;

    c.rgb *= vec3(0.995, 1.006, 1.012);

    fragColor = vec4(c.rgb, c.a);
}
