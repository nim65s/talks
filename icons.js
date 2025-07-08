const fs = require("fs");
const path = require("path");
const simpleIcons = require("simple-icons");

const brands = ["creativecommons", "github", "gitlab"];
const output = path.join(__dirname, "public");

for (const icon of Object.values(simpleIcons)) {
	if (brands.includes(icon.slug)) {
		const filePath = path.join(output, `${icon.slug}.svg`);
		const svg = icon.svg.replace(
			"svg ",
			'svg class="w-8 h-8" fill="currentColor" ',
		);
		fs.writeFileSync(filePath, svg, "utf8");
	}
}
