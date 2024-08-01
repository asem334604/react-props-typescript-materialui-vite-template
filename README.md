

# Create an App with React, Props, and Material UI

Welcome to this tutorial on building an app using React, Props, and Material UI. This guide will take you through the essential steps and concepts needed to create a robust and stylish application.

## Table of Contents

1. [Introduction](#introduction)
2. [Setting Up the Project](#setting-up-the-project)
3. [Commonly Used Components and Separation of Concerns](#commonly-used-components-and-separation-of-concerns)
4. [Handling State Changes in Manager Component](#handling-state-changes-in-manager-component)
5. [Passing Functions and Objects as Props in React](#passing-functions-and-objects-as-props-in-react)
6. [Defining Types and Components for Props in React](#defining-types-and-components-for-props-in-react)
7. [Handling State Changes in Manager Component](#handling-state-changes-in-manager-component-1)
8. [Creating a Compound Component in React with TypeScript](#creating-a-compound-component-in-react-with-typeScript)
8. [Optimizing for INP and Loading Performance](#optimizing-for-inp-and-loading-performance)

---

## Introduction

In this tutorial, we will learn how to create a React application that uses props for data management and Material UI for styling. We will cover the basics of setting up the project, creating components, and applying styles.

## Setting Up the Project

To start, we need to set up our React project by cloning it from a Git repository and installing the necessary dependencies. Follow these steps to get started:

1. **Clone the Repository**: Use the following command to clone the project repository:

    ```bash
    git clone https://github.com/your-username/your-repo.git
    cd your-repo
    ```

2. **Install Dependencies**: Run the following command to install the necessary dependencies:

    ```bash
    npm install
    ```

## Commonly Used Components and Separation of Concerns

In this chapter, we will explore some commonly used React components and learn how to use them effectively with the separation of concerns approach. This will help in managing the complexity and maintaining a clean architecture for your application.

### Summary

In this chapter, we've covered:
- **SearchForm**: A form component with search input and a submit button. Demonstrated how to use it with `onSearchChange` and `onSubmit` handlers.
- **MoviesList**: A list component that displays movies and handles adding/removing favorites.
- **RadioButtonGroup**: A component for rendering a group of radio buttons, used with an `onChange` handler.
- **CheckboxGroup**: A component for rendering a group of checkboxes, used with an `onChange` handler.

### 1. **SearchForm Component**

The `SearchForm` component is used to handle search input from the user.

#### Implementation

```javascript
import React from 'react';
import TextField from '@mui/material/TextField';
import Typography from '@mui/material/Typography';
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';

interface SearchFormProps {
    onSearchChange(newQuery: string): void;
    onSubmit: () => void;
}

const SearchForm: React.FC<SearchFormProps> = ({ onSearchChange, onSubmit }) => {
    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        onSearchChange(e.target.value);
    };

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        onSubmit();
    };

    return (
        <form onSubmit={handleSubmit}>
            <Box sx={{ mb: 4 }}>
                <Typography variant="h6">The TV Series Database</Typography>
            </Box>
            <TextField
                id="tv-series-search"
                type="search"
                placeholder="Search..."
                fullWidth
                variant="outlined"
                onChange={handleChange}
            />
            <Button type="submit" variant="contained" sx={{ mt: 2 }}>Search</Button>
        </form>
    );
};

export default SearchForm;
```

#### Usage in Another Component

```javascript
import React, { useState } from 'react';
import SearchForm from './SearchForm';

const MovieManager = () => {
    const [query, setQuery] = useState("");

    const handleSearchChange = (searchValue: string) => {
        setQuery(searchValue);
    };

    const handleSubmit = () => {
        console.log("Search submitted with query:", query);
    };

    return (
        <div>
            <SearchForm onSearchChange={handleSearchChange} onSubmit={handleSubmit} />
        </div>
    );
};

export default MovieManager;
```

### 2. **MoviesList Component**

The `MoviesList` component is responsible for rendering a list of movies.

#### Implementation

```javascript
import React from 'react';
import { Movie } from "./Movie";
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import CardMedia from '@mui/material/CardMedia';
import IconButton from '@mui/material/IconButton';
import Typography from '@mui/material/Typography';
import FavoriteIcon from '@mui/icons-material/Favorite';
import Box from "@mui/material/Box";

interface MoviesListProps {
    movies: Movie[];
    addToFavorites(id: number): void;
    removeFromFavorites(id: number): void;
}

const MoviesList: React.FC<MoviesListProps> = ({ movies, addToFavorites, removeFromFavorites }) => {
    const toggleFavorite = (movie: Movie) => {
        movie.isFavorite ? removeFromFavorites(movie.id) : addToFavorites(movie.id);
    };

    const moviesList = movies.map((movie) => (
        <Box key={movie.id}>
            <Card sx={{ display: "flex", maxWidth: 350, marginBottom: 4 }}>
                <CardMedia
                    component="img"
                    sx={{ flexGrow: 1, height: 200, width: 80, objectFit: 'contain' }}
                    image={movie.image}
                    alt={movie.name}
                />
                <CardContent sx={{ flexGrow: 3 }}>
                    <Box sx={{ display: "flex", alignItems: "center", maxWidth: 270 }}>
                        <Typography flexGrow={4} gutterBottom variant="h5" component="div">
                            {movie.name}
                        </Typography>
                        <IconButton
                            aria-label="add to favorites"
                            onClick={() => toggleFavorite(movie)}
                        >
                            <FavoriteIcon sx={movie.isFavorite ? { color: "red" } : { color: "white" }} />
                        </IconButton>
                    </Box>
                    <Typography variant="body2" color="text.secondary">
                        Score: {movie.score.toFixed(2)}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                        {movie.genres[0]} {movie.genres[1] ? `| ${movie.genres[1]}` : ''}
                    </Typography>
                </CardContent>
            </Card>
        </Box>
    ));

    return <div>{moviesList}</div>;
};

export default MoviesList;
```

#### Usage in Another Component

```javascript
import React, { useState, useEffect } from 'react';
import MoviesList from './MoviesList';
import { Movie } from './Movie';

const MovieManager = () => {
    const [movies, setMovies] = useState<Movie[]>([]);

    const addToFavorites = (id: number) => {
        setMovies(prevMovies => prevMovies.map(movie => 
            movie.id === id ? { ...movie, isFavorite: true } : movie
        ));
    };

    const removeFromFavorites = (id: number) => {
        setMovies(prevMovies => prevMovies.map(movie => 
            movie.id === id ? { ...movie, isFavorite: false } : movie
        ));
    };

    useEffect(() => {
        // Fetch movies from an API or local data
        const fetchMovies = async () => {
            // Simulate fetching data
            const moviesData: Movie[] = [
                { id: 1, name: 'Movie 1', image: 'image1.jpg', isFavorite: false, score: 8.0, genres: ['Drama'] },
                // Add more movies here
            ];
            setMovies(moviesData);
        };

        fetchMovies();
    }, []);

    return (
        <div>
            <MoviesList 
                movies={movies} 
                addToFavorites={addToFavorites} 
                removeFromFavorites={removeFromFavorites} 
            />
        </div>
    );
};

export default MovieManager;
```

### 3. **Radio Button Component**

A basic radio button component using Material UI.

#### Implementation

```javascript
import React from 'react';
import Radio from '@mui/material/Radio';
import RadioGroup from '@mui/material/RadioGroup';
import FormControlLabel from '@mui/material/FormControlLabel';
import FormControl from '@mui/material/FormControl';
import FormLabel from '@mui/material/FormLabel';

interface RadioButtonGroupProps {
    options: string[];
    selectedValue: string;
    onChange: (value: string) => void;
}

const RadioButtonGroup: React.FC<RadioButtonGroupProps> = ({ options, selectedValue, onChange }) => {
    const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
        onChange((event.target as HTMLInputElement).value);
    };

    return (
        <FormControl component="fieldset">
            <FormLabel component="legend">Choose an option</FormLabel>
            <RadioGroup value={selectedValue} onChange={handleChange}>
                {options.map(option => (
                    <FormControlLabel key={option} value={option} control={<Radio />} label={option} />
               

 ))}
            </RadioGroup>
        </FormControl>
    );
};

export default RadioButtonGroup;
```

### 4. **Checkbox Component**

A basic checkbox component using Material UI.

#### Implementation

```javascript
import React from 'react';
import Checkbox from '@mui/material/Checkbox';
import FormControlLabel from '@mui/material/FormControlLabel';
import FormGroup from '@mui/material/FormGroup';

interface CheckboxGroupProps {
    options: string[];
    selectedValues: string[];
    onChange: (value: string) => void;
}

const CheckboxGroup: React.FC<CheckboxGroupProps> = ({ options, selectedValues, onChange }) => {
    const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
        const value = (event.target as HTMLInputElement).value;
        onChange(value);
    };

    return (
        <FormGroup>
            {options.map(option => (
                <FormControlLabel
                    key={option}
                    control={
                        <Checkbox
                            checked={selectedValues.includes(option)}
                            onChange={handleChange}
                            value={option}
                        />
                    }
                    label={option}
                />
            ))}
        </FormGroup>
    );
};

export default CheckboxGroup;
```

## Handling State Changes in Manager Component

In this section, we will explore how to handle state changes in the manager component, focusing on adding, removing, updating items, and toggling properties.

### Handling State Changes

1. **Adding an Item**

   ```javascript
   const handleAddItem = (item: Item) => {
       setItems(prevItems => [...prevItems, item]);
   };
   ```

2. **Removing an Item**

   ```javascript
   const handleRemoveItem = (itemId: number) => {
       setItems(prevItems => prevItems.filter(item => item.id !== itemId));
   };
   ```

3. **Updating an Item**

   ```javascript
   const handleUpdateItem = (updatedItem: Item) => {
       setItems(prevItems => prevItems.map(item =>
           item.id === updatedItem.id ? updatedItem : item
       ));
   };
   ```

4. **Toggling Properties**

   ```javascript
   const handleToggleProperty = (itemId: number, property: string) => {
       setItems(prevItems => prevItems.map(item =>
           item.id === itemId ? { ...item, [property]: !item[property] } : item
       ));
   };
   ```

## Passing Functions and Objects as Props in React

When passing functions and objects as props in React, you can manage component interactions and state updates effectively. Here's how to handle it:

### Example Usage

```javascript
import React, { useState } from 'react';

interface Item {
    id: number;
    name: string;
    isFavorite: boolean;
}

const ParentComponent = () => {
    const [items, setItems] = useState<Item[]>([]);

    const handleAddItem = (item: Item) => {
        setItems(prevItems => [...prevItems, item]);
    };

    return (
        <ChildComponent onAddItem={handleAddItem} />
    );
};

interface ChildComponentProps {
    onAddItem: (item: Item) => void;
}

const ChildComponent: React.FC<ChildComponentProps> = ({ onAddItem }) => {
    const newItem: Item = { id: 1, name: 'New Item', isFavorite: false };

    return (
        <button onClick={() => onAddItem(newItem)}>Add Item</button>
    );
};
```

## Defining Types and Components for Props in React

Defining types for props helps in ensuring type safety and better code maintainability. Here's an example of how to define types and components:

### Example

```typescript
import React from 'react';

interface Item {
    id: number;
    name: string;
    isFavorite: boolean;
}

interface ItemListProps {
    items: Item[];
    onItemToggle: (id: number) => void;
}

const ItemList: React.FC<ItemListProps> = ({ items, onItemToggle }) => (
    <ul>
        {items.map(item => (
            <li key={item.id}>
                {item.name}
                <button onClick={() => onItemToggle(item.id)}>
                    {item.isFavorite ? 'Unfavorite' : 'Favorite'}
                </button>
            </li>
        ))}
    </ul>
);
```


# Creating a Compound Component in React with TypeScript

## Introduction

In this tutorial, we will learn how to create a compound component in React using TypeScript. Compound components allow for flexible and reusable UI components by letting you combine smaller components to build a larger, more complex component. We will also demonstrate how to add new properties to the compound component.

## Step 1: Define Prop Types for Child Components

First, define the prop types for each of the child components. This ensures that each component receives the correct props, providing type safety and preventing runtime errors.

```typescript
import React, { createContext, useContext, ReactNode } from 'react';

interface ProductImageProps {
  src: string;
  alt: string;
}

interface ProductTitleProps {
  children: ReactNode;
}

interface ProductDescriptionProps {
  children: ReactNode;
}

interface ProductPriceProps {
  children: ReactNode;
}

interface ProductButtonProps {
  children: ReactNode;
  onClick: () => void;
}

interface ProductRatingProps {
  rating: number;
}
```

## Step 2: Create Child Components with Props

Create the child components using the defined prop types. Each component will handle its specific part of the product card.

```typescript
const ProductImage: React.FC<ProductImageProps> = ({ src, alt }) => {
  return <img src={src} alt={alt} className="product-image" />;
};

const ProductTitle: React.FC<ProductTitleProps> = ({ children }) => {
  return <h2 className="product-title">{children}</h2>;
};

const ProductDescription: React.FC<ProductDescriptionProps> = ({ children }) => {
  return <p className="product-description">{children}</p>;
};

const ProductPrice: React.FC<ProductPriceProps> = ({ children }) => {
  return <p className="product-price">{children}</p>;
};

const ProductButton: React.FC<ProductButtonProps> = ({ children, onClick }) => {
  return <button onClick={onClick} className="product-button">{children}</button>;
};

const ProductRating: React.FC<ProductRatingProps> = ({ rating }) => {
  return <div className="product-rating">Rating: {rating} / 5</div>;
};
```

## Step 3: Create the Context and Main Component

Next, create a context for the product card and define the main `ProductCard` component. This component will act as the wrapper for all the child components.

```typescript
interface ProductCardContextProps {}

const ProductCardContext = createContext<ProductCardContextProps>({});

interface ProductCardProps {
  children: ReactNode;
}

const ProductCard: React.FC<ProductCardProps> & {
  Image: React.FC<ProductImageProps>;
  Title: React.FC<ProductTitleProps>;
  Description: React.FC<ProductDescriptionProps>;
  Price: React.FC<ProductPriceProps>;
  Button: React.FC<ProductButtonProps>;
  Rating: React.FC<ProductRatingProps>;
} = ({ children }) => {
  return (
    <ProductCardContext.Provider value={{}}>
      <div className="product-card">
        {children}
      </div>
    </ProductCardContext.Provider>
  );
};
```

## Step 4: Attach Child Components to the Main Component

Attach the child components to the `ProductCard` component using dot notation. This allows you to use these components as properties of the main component.

```typescript
ProductCard.Image = ProductImage;
ProductCard.Title = ProductTitle;
ProductCard.Description = ProductDescription;
ProductCard.Price = ProductPrice;
ProductCard.Button = ProductButton;
ProductCard.Rating = ProductRating;

export default ProductCard;
```

## Step 5: Use the Compound Component in an Application

Finally, use the `ProductCard` compound component in your application. This demonstrates how you can easily combine the smaller components to create a complete product card.

```typescript
const App: React.FC = () => (
  <ProductCard>
    <ProductCard.Image src="path/to/image.jpg" alt="Product Image" />
    <ProductCard.Title>Product Title</ProductCard.Title>
    <ProductCard.Description>This is a description of the product.</ProductCard.Description>
    <ProductCard.Price>$19.99</ProductCard.Price>
    <ProductCard.Rating rating={4.5} />
    <ProductCard.Button onClick={() => alert('Added to cart')}>Add to Cart</ProductCard.Button>
  </ProductCard>
);

export default App;
```

## Summary

By defining the prop types at the component level and using them correctly in the application, TypeScript ensures that all components are used with the correct props, providing type safety and avoiding runtime errors. In this setup, as long as the props for each child component (`ProductImage`, `ProductTitle`, `ProductDescription`, `ProductPrice`, `ProductButton`, `ProductRating`) are correctly defined, TypeScript will enforce the prop types automatically when these components are used within the `ProductCard`.

## Adding a New Property to the Compound Component

To add a new property to the compound component, follow these steps:

1. **Define the Prop Types**: Define the prop types for the new child component.
2. **Create the Child Component**: Create the child component using the defined prop types.
3. **Attach the Child Component**: Attach the new child component to the main `ProductCard` component using dot notation.

### Example: Adding a `ProductReview` Component

1. **Define Prop Types**:

```typescript
interface ProductReviewProps {
  reviews: string[];
}
```

2. **Create the Child Component**:

```typescript
const ProductReview: React.FC<ProductReviewProps> = ({ reviews }) => {
  return (
    <div className="product-reviews">
      {reviews.map((review, index) => (
        <p key={index}>{review}</p>
      ))}
    </div>
  );
};
```

3. **Attach the Child Component**:

```typescript
ProductCard.Review = ProductReview;
```

You can now use the `ProductReview` component as a property of `ProductCard`.

```typescript
const App: React.FC = () => (
  <ProductCard>
    <ProductCard.Image src="path/to/image.jpg" alt="Product Image" />
    <ProductCard.Title>Product Title</ProductCard.Title>
    <ProductCard.Description>This is a description of the product.</ProductCard.Description>
    <ProductCard.Price>$19.99</ProductCard.Price>
    <ProductCard.Rating rating={4.5} />
    <ProductCard.Button onClick={() => alert('Added to cart')}>Add to Cart</ProductCard.Button>
    <ProductCard.Review reviews={['Great product!', 'Highly recommend.']} />
  </ProductCard>
);

export default App;
```
``

## Optimizing for INP and Loading Performance

In this section, we will discuss optimization techniques for improving Interactivity to Next Paint (INP) and loading performance using React features.

### Optimization Techniques

1. **React.lazy and Suspense**

   ```javascript
   import React, { Suspense } from 'react';

   const LazyComponent = React.lazy(() => import('./LazyComponent'));

   const App = () => (
       <Suspense fallback={<div>Loading...</div>}>
           <LazyComponent />
       </Suspense>
   );
   ```

2. **useMemo**

   ```javascript
   import React, { useMemo } from 'react';

   const Component = ({ items }) => {
       const processedItems = useMemo(() => items.map(item => item * 2), [items]);

       return (
           <ul>
               {processedItems.map(item => <li key={item}>{item}</li>)}
           </ul>
       );
   };
   ```

3. **useCallback**

   ```javascript
   import React, { useCallback } from 'react';

   const Component = ({ onClick }) => {
       const handleClick = useCallback(() => {
           onClick();
       }, [onClick]);

       return <button onClick={handleClick}>Click me</button>;
   };
   ```

4. **useTransition**

   ```javascript
   import React, { useState, useTransition } from 'react';

   const Component = () => {
       const [isPending, startTransition] = useTransition();
       const [value, setValue] = useState('');

       const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
           startTransition(() => {
               setValue(e.target.value);
           });
       };

       return (
           <div>
               <input type="text" value={value} onChange={handleChange} />
               {isPending ? <div>Loading...</div> : <div>{value}</div>}
           </div>
       );
   };
   ```

---
