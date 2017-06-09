function showGradient(ValoresGradiente)
 surface(ValoresGradiente)
 colorbar;
 caxis([min(ValoresGradiente(:)) max(ValoresGradiente(:))]);
end