-- Remove trailing numbers from Quarto cross-reference links

function Link(el)
    -- Only touch quarto-xref links
    if not el.classes:includes("quarto-xref") then
        return el
    end

    -- Filter only for sections
    local href = el.target
    if not (href:match("#sec-")) then
        return el
    end

    -- Remove section numbers
    local newContent = {}
    for i = 1, #el.content - 2 do
        newContent[#newContent + 1] = el.content[i]
    end

    el.content = newContent

    return el
end
