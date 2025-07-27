#!/usr/bin/env python3
"""
Script to update the markdown table in L4.md from the CSV file
"""

import csv


def csv_to_markdown_table(csv_file_path):
    """Convert CSV data to markdown table format"""
    with open(csv_file_path, "r") as csvfile:
        reader = csv.reader(csvfile)
        rows = list(reader)

    # Header row with LaTeX symbols
    header = "| Moment | Im1, Original | Im2, Translated | Im3, Scaled | Im4, Rotated $45^\\circ$ | Im5, Rotated $90^\\circ$ | Im6, Flipped |"
    separator = "|--------|---------------|-----------------|-------------|-------------------------|-------------------------|----------------|"

    # Data rows
    table_rows = [header, separator]

    for row in rows[1:]:  # Skip CSV header
        moment = row[0]
        values = [f"{float(val):.3f}" for val in row[1:]]
        table_row = f"| {moment} | {' | '.join(values)} |"
        table_rows.append(table_row)

    return "\n    ".join([""] + table_rows)


def update_markdown_file(md_file_path, csv_file_path):
    """Update the markdown file with new table data from CSV"""
    # Read the current markdown file
    with open(md_file_path, "r") as f:
        content = f.read()

    # Generate new table
    new_table = csv_to_markdown_table(csv_file_path)

    # Find the start and end of the table section
    start_marker = "<!-- Table data automatically generated from ../out/moment_invariants_table.csv -->"
    end_marker = "Table: Hu's Moment Invariants for all image transformations"

    start_pos = content.find(start_marker)
    end_pos = content.find(end_marker)

    if start_pos != -1 and end_pos != -1:
        # Replace the section between markers
        before = content[:start_pos]
        after = content[end_pos:]
        replacement = f"<!-- Table data automatically generated from ../out/moment_invariants_table.csv -->\n{new_table}\n\n    "
        new_content = before + replacement + after

        # Write the updated content back
        with open(md_file_path, "w") as f:
            f.write(new_content)

        print(f"Updated {md_file_path} with data from {csv_file_path}")
    else:
        print("Could not find table markers in the markdown file")


if __name__ == "__main__":
    csv_path = "../out/moment_invariants_table.csv"
    md_path = "L4.md"

    try:
        update_markdown_file(md_path, csv_path)
        print("Table update completed successfully!")
    except Exception as e:
        print(f"Error updating table: {e}")
