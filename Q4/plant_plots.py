import argparse
import matplotlib.pyplot as plt

def main():
    
    parser = argparse.ArgumentParser(description="Generate plant plots from command line arguments.")
    parser.add_argument("--plant", type=str, default="Rose", help="Name of the plant")
    parser.add_argument("--height", nargs='+', type=float, help="Height data (cm)")
    parser.add_argument("--leaf_count", nargs='+', type=int, help="Leaf count data")
    parser.add_argument("--dry_weight", nargs='+', type=float, help="Dry weight data (g)")
    
    args = parser.parse_args()
    
    
    plant = args.plant
    height_data = args.height or []
    leaf_count_data = args.leaf_count or []
    dry_weight_data = args.dry_weight or []
    
    
    print(f"Plant: {plant}")
    print(f"Height data: {height_data} cm")
    print(f"Leaf count data: {leaf_count_data}")
    print(f"Dry weight data: {dry_weight_data} g")
    
    
    if not (len(height_data) == len(leaf_count_data) == len(dry_weight_data)):
        print("Warning: The lists height, leaf_count, and dry_weight do not have the same length.")
    
    
    plt.figure(figsize=(10, 6))
    plt.scatter(height_data, leaf_count_data, color='b')
    plt.title(f'Height vs Leaf Count for {plant}')
    plt.xlabel('Height (cm)')
    plt.ylabel('Leaf Count')
    plt.grid(True)
    scatter_file = f"{plant}_scatter.png"
    plt.savefig(scatter_file)
    plt.close()
    
    
    plt.figure(figsize=(10, 6))
    plt.hist(dry_weight_data, bins=5, color='g', edgecolor='black')
    plt.title(f'Histogram of Dry Weight for {plant}')
    plt.xlabel('Dry Weight (g)')
    plt.ylabel('Frequency')
    plt.grid(True)
    hist_file = f"{plant}_histogram.png"
    plt.savefig(hist_file)
    plt.close()
    
    
    weeks = [f"Week {i+1}" for i in range(len(height_data))]
    
    plt.figure(figsize=(10, 6))
    plt.plot(weeks, height_data, marker='o', color='r')
    plt.title(f'{plant} Height Over Time')
    plt.xlabel('Week')
    plt.ylabel('Height (cm)')
    plt.grid(True)
    line_file = f"{plant}_line_plot.png"
    plt.savefig(line_file)
    plt.close()
    
    print(f"Generated plots for {plant}:")
    print(f"  Scatter plot: {scatter_file}")
    print(f"  Histogram:   {hist_file}")
    print(f"  Line plot:   {line_file}")

if __name__ == "__main__":
    main()
