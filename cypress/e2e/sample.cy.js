// cypress/e2e/sample.cy.js
describe('Sample Test', () => {
    it('Visits the app', () => {
      cy.visit('/');
      cy.contains('Hello');
    });
  });