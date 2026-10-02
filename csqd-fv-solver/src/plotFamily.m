function plotFamily(ax, x, Ecell, mvals, type)
% Colour code: black m=0, blue |m|=1, red |m|=2; labels at the right end.
    for im = 1:numel(mvals)
        m  = mvals(im);
        switch abs(m), case 0, c = 'k'; case 1, c = 'b'; otherwise, c = 'r'; end
        Em = Ecell{im};
        for j = 1:size(Em,2)
            plot(ax, x, Em(:,j), 'Color', c, 'LineWidth', 1.5);
            if m == 0,            lab = 'm = 0';
            elseif type == 'F',   lab = sprintf('\\pm%d', m);
            elseif m > 0,         lab = sprintf('+%d', m);
            else,                 lab = sprintf('%d', m);
            end
            text(ax, x(end) + 0.02*(x(end)-x(1)), Em(end,j), lab, 'Color', c, 'FontSize', 9, 'FontWeight', 'bold');
        end
    end
end