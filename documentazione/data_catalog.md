# Data Catalog per Gold Layer

## Panoramica
Il Gold Layer è la rappresentazione dei dati a livello business, strutturata per supportare casi d'uso analitici e di reporting. È costituito da **dimension tables** e **fact tables** per specifiche metriche aziendali.

---

### 1. **gold.dim_customers**
- **Scopo:** Memorizza i dettagli dei clienti arricchiti con dati demografici e geografici.
- **Colonne:**

| Nome Colonna     | Tipo di Dato  | Descrizione                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| customer_key     | INTEGER       | Surrogate key che identifica univocamente ogni record del cliente nella dimension table.      |
| customer_id      | INTEGER       | Identificatore numerico univoco assegnato a ciascun cliente.                                  |
| customer_number  | VARCHAR(50)   | Identificatore alfanumerico che rappresenta il cliente, utilizzato per tracciamento e riferimento. |
| first_name       | VARCHAR(50)   | Il nome del cliente, come registrato nel sistema.                                             |
| last_name        | VARCHAR(50)   | Il cognome del cliente.                                                                       |
| country          | VARCHAR(50)   | Il paese di residenza del cliente (es. 'Australia').                                          |
| marital_status   | VARCHAR(50)   | Lo stato civile del cliente (es. 'Married', 'Single').                                        |
| gender           | VARCHAR(50)   | Il genere del cliente (es. 'Male', 'Female', 'n/a').                                          |
| birthdate        | DATE          | La data di nascita del cliente, formattata come YYYY-MM-DD (es. 1971-10-06).                 |
| create_date      | DATE          | La data in cui il record del cliente è stato creato nel sistema.                              |

---

### 2. **gold.dim_products**
- **Scopo:** Fornisce informazioni sui prodotti e i loro attributi.
- **Colonne:**

| Nome Colonna        | Tipo di Dato  | Descrizione                                                                                   |
|---------------------|---------------|-----------------------------------------------------------------------------------------------|
| product_key         | INTEGER       | Surrogate key che identifica univocamente ogni record del prodotto nella dimension table.     |
| product_id          | INTEGER       | Un identificatore univoco assegnato al prodotto per tracciamento e riferimento interno.       |
| product_number      | VARCHAR(50)   | Un codice alfanumerico strutturato che rappresenta il prodotto, spesso utilizzato per categorizzazione o inventario. |
| product_name        | VARCHAR(50)   | Nome descrittivo del prodotto, inclusi dettagli chiave come tipo, colore e dimensione.        |
| category_id         | VARCHAR(50)   | Un identificatore univoco per la categoria del prodotto, che collega alla sua classificazione di alto livello. |
| category            | VARCHAR(50)   | La classificazione più ampia del prodotto (es. Bikes, Components) per raggruppare articoli correlati. |
| subcategory         | VARCHAR(50)   | Una classificazione più dettagliata del prodotto all'interno della categoria, come il tipo di prodotto. |
| maintenance_required| VARCHAR(50)   | Indica se il prodotto richiede manutenzione (es. 'Yes', 'No').                                |
| cost                | INTEGER       | Il costo o prezzo base del prodotto, misurato in unità monetarie.                             |
| product_line        | VARCHAR(50)   | La linea di prodotto specifica o serie a cui appartiene il prodotto (es. Road, Mountain).     |
| start_date          | DATE          | La data in cui il prodotto è diventato disponibile per la vendita o l'uso.                    |

---

### 3. **gold.fact_sales**
- **Scopo:** Memorizza i dati transazionali delle vendite per scopi analitici.
- **Colonne:**

| Nome Colonna    | Tipo di Dato  | Descrizione                                                                                   |
|-----------------|---------------|-----------------------------------------------------------------------------------------------|
| order_number    | VARCHAR(50)   | Un identificatore alfanumerico univoco per ogni ordine di vendita (es. 'SO54496').            |
| product_key     | INTEGER       | Surrogate key che collega l'ordine alla dimension table dei prodotti.                         |
| customer_key    | INTEGER       | Surrogate key che collega l'ordine alla dimension table dei clienti.                          |
| order_date      | DATE          | La data in cui l'ordine è stato effettuato.                                                   |
| shipping_date   | DATE          | La data in cui l'ordine è stato spedito al cliente.                                           |
| due_date        | DATE          | La data in cui il pagamento dell'ordine era dovuto.                                           |
| sales_amount    | INTEGER       | Il valore monetario totale della vendita per il line item, in unità di valuta intere (es. 25). |
| quantity        | INTEGER       | Il numero di unità del prodotto ordinate per il line item (es. 1).                            |
| price           | INTEGER       | Il prezzo per unità del prodotto per il line item, in unità di valuta intere (es. 25).        |