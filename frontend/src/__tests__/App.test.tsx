import React from 'react';
import { render, screen } from '@testing-library/react';
import App from '../App';

it('should render "Squire - coming soon!"', () => {
  render(<App />);
  const splashText = screen.getByText(/squire - coming soon!/i);
  expect(splashText).toBeInTheDocument();
});
