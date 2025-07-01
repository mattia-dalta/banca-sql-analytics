
-- FINAL QUERY WITH CUSTOMER METRICS AND ACCOUNT FEATURES

-- cl = cliente, tt = tipo_transazione, co = conto, tc = tipo_conto, tr = transazioni

select     
    cl.id_cliente,   
    
    -- customer's age
    -- Calculate customer's age as the difference between current date and birth date.
    -- Since we group by id_cliente and each customer has only one birth date,
    -- using MAX() ensures syntactical correctness without altering the result. It's just becouse i want to use only client_id column for the group by
    -- It returns the correct age for each unique customer.
    
    max(timestampdiff(year, cl.data_nascita, current_date())) as eta,             

    -- number of outgoing and incoming transactions
    count(case when tt.segno = '-' then 1 end) as numero_transazioni_uscita,
    count(case when tt.segno = '+' then 1 end) as numero_transazioni_entrata,

    -- total amount of outgoing and incoming transactions
    round(sum(case when tt.segno = '-' then tr.importo else 0 end), 2) as totale_uscite,
    round(sum(case when tt.segno = '+' then tr.importo else 0 end), 2) as totale_entrate,

    -- total number of accounts
    count(distinct co.id_conto) as nr_conti_poss,

    -- number of accounts by account type
    count(distinct case when tc.desc_tipo_conto = 'conto base' then co.id_conto end) as n_conto_base,
    count(distinct case when tc.desc_tipo_conto = 'conto business' then co.id_conto end) as n_conto_business,
    count(distinct case when tc.desc_tipo_conto = 'conto privati' then co.id_conto end) as n_conto_privati,
    count(distinct case when tc.desc_tipo_conto = 'conto famiglie' then co.id_conto end) as n_conto_famiglie,

    -- transaction counts and totals by account type: conto base
    count(case when tt.segno = '-' and tc.desc_tipo_conto = 'conto base' then 1 end) as trans_uscita_base,
    count(case when tt.segno = '+' and tc.desc_tipo_conto = 'conto base' then 1 end) as trans_entrata_base,
    round(sum(case when tt.segno = '-' and tc.desc_tipo_conto = 'conto base' then tr.importo else 0 end), 2) as importo_uscita_base,
    round(sum(case when tt.segno = '+' and tc.desc_tipo_conto = 'conto base' then tr.importo else 0 end), 2) as importo_entrata_base,

    -- conto business
    count(case when tt.segno = '-' and tc.desc_tipo_conto = 'conto business' then 1 end) as trans_uscita_business,
    count(case when tt.segno = '+' and tc.desc_tipo_conto = 'conto business' then 1 end) as trans_entrata_business,
    round(sum(case when tt.segno = '-' and tc.desc_tipo_conto = 'conto business' then tr.importo else 0 end), 2) as importo_uscita_business,
    round(sum(case when tt.segno = '+' and tc.desc_tipo_conto = 'conto business' then tr.importo else 0 end), 2) as importo_entrata_business,

    -- conto privati
    count(case when tt.segno = '-' and tc.desc_tipo_conto = 'conto privati' then 1 end) as trans_uscita_privati,
    count(case when tt.segno = '+' and tc.desc_tipo_conto = 'conto privati' then 1 end) as trans_entrata_privati,
    round(sum(case when tt.segno = '-' and tc.desc_tipo_conto = 'conto privati' then tr.importo else 0 end), 2) as importo_uscita_privati,
    round(sum(case when tt.segno = '+' and tc.desc_tipo_conto = 'conto privati' then tr.importo else 0 end), 2) as importo_entrata_privati,

    -- conto famiglie
    count(case when tt.segno = '-' and tc.desc_tipo_conto = 'conto famiglie' then 1 end) as trans_uscita_famiglie,
    count(case when tt.segno = '+' and tc.desc_tipo_conto = 'conto famiglie' then 1 end) as trans_entrata_famiglie,
    round(sum(case when tt.segno = '-' and tc.desc_tipo_conto = 'conto famiglie' then tr.importo else 0 end), 2) as importo_uscita_famiglie,
    round(sum(case when tt.segno = '+' and tc.desc_tipo_conto = 'conto famiglie' then tr.importo else 0 end), 2) as importo_entrata_famiglie

from banca.cliente cl
left join banca.conto co
    on cl.id_cliente = co.id_cliente
left join banca.tipo_conto tc
    on co.id_tipo_conto = tc.id_tipo_conto
left join banca.transazioni tr
    on co.id_conto = tr.id_conto
left join banca.tipo_transazione tt
    on tr.id_tipo_trans = tt.id_tipo_transazione

group by 1;


-- Verifing if the number of clients in the final table are equal to the original table 

select count(*) as numero_clienti_finali
from (
    select cl.id_cliente
    from banca.cliente cl
    left join banca.conto co
        on cl.id_cliente = co.id_cliente
    left join banca.tipo_conto tc
        on co.id_tipo_conto = tc.id_tipo_conto
    left join banca.transazioni tr
        on co.id_conto = tr.id_conto
    left join banca.tipo_transazione tt
        on tr.id_tipo_trans = tt.id_tipo_transazione
    group by cl.id_cliente
) as clienti_finali;

select count(*) as numero_clienti_originali
from banca.cliente;

