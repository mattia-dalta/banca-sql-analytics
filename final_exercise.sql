-- This block checks for null values in key columns of each table.
-- Since all results returned 0, it means all the join keys are fully populated.
-- Therefore, we can safely use INNER JOINs in the queries below.

-- Check for nulls in cliente table
select
  sum(case when id_cliente is null then 1 else 0 end) as cliente_senza_id,
  sum(case when data_nascita is null then 1 else 0 end) as cliente_senza_data_nascita
from banca.cliente;

-- Check for nulls in conto table
select
  sum(case when id_conto is null then 1 else 0 end) as conto_senza_id,
  sum(case when id_cliente is null then 1 else 0 end) as conto_senza_cliente,
  sum(case when id_tipo_conto is null then 1 else 0 end) as conto_senza_tipo
from banca.conto;

-- Check for nulls in transazioni table
select
  sum(case when importo is null then 1 else 0 end) as transazione_senza_id,
  sum(case when id_conto is null then 1 else 0 end) as transazione_senza_conto,
  sum(case when id_tipo_trans is null then 1 else 0 end) as transazione_senza_tipo
from banca.transazioni;

-- Check for nulls in tipo_transazione table
select
  sum(case when id_tipo_transazione is null then 1 else 0 end) as tipo_trans_senza_id,
  sum(case when segno is null then 1 else 0 end) as tipo_trans_senza_segno,
  sum(case when desc_tipo_trans is null then 1 else 0 end) as tipo_trans_senza_descrizione
from banca.tipo_transazione;

-- Check for nulls in tipo_conto table
select
  sum(case when id_tipo_conto is null then 1 else 0 end) as tipo_conto_senza_id,
  sum(case when desc_tipo_conto is null then 1 else 0 end) as tipo_conto_senza_descrizione
from banca.tipo_conto;

-- FINAL QUERY WITH CUSTOMER METRICS AND CONTACT INFO

-- cl = cliente, tt = tipo_transazioni, co = conto, tc = tipo_conto, tr = transazione

select     
    cl.id_cliente,                                                     
    max(timestampdiff(year, cl.data_nascita, curdate())) as eta,             -- età del cliente
    
-- nnumero di transazioni (uscita, entrata)
    count(case when tt.segno = '-' then 1 end) as numero_transazioni_uscita,
    count(case when tt.segno = '+' then 1 end) as numero_transazioni_entrata,

-- totale uscite e totale entrate (importo)

    round(sum(case when tt.segno = '-' then tr.importo else 0 end), 2) as totale_uscite,
    round(sum(case when tt.segno = '+' then tr.importo else 0 end), 2) as totale_entrate,

-- numero di conti posseduti

    count(distinct co.id_conto) as nr_conti_poss,

-- numero di conti posseduti per tipologia 

    count(distinct case when tc.desc_tipo_conto = 'conto base' then co.id_conto end) as n_conto_base,
    count(distinct case when tc.desc_tipo_conto = 'conto business' then co.id_conto end) as n_conto_business,
    count(distinct case when tc.desc_tipo_conto = 'conto privati' then co.id_conto end) as n_conto_privati,
    count(distinct case when tc.desc_tipo_conto = 'conto famiglie' then co.id_conto end) as n_conto_famiglie,

-- numero di transazioni in uscita ed in entrata e di importo per tipologia di conto (base)

    count(case when tt.segno = '-' and tc.desc_tipo_conto = 'conto base' then 1 end) as trans_uscita_base,
    count(case when tt.segno = '+' and tc.desc_tipo_conto = 'conto base' then 1 end) as trans_entrata_base,
    round(sum(case when tt.segno = '-' and tc.desc_tipo_conto = 'conto base' then tr.importo else 0 end), 2) as importo_uscita_base,
    round(sum(case when tt.segno = '+' and tc.desc_tipo_conto = 'conto base' then tr.importo else 0 end), 2) as importo_entrata_base,
    
    -- numero di transazioni in uscita ed in entrata e di importo per tipologia di conto (business)

    count(case when tt.segno = '-' and tc.desc_tipo_conto = 'conto business' then 1 end) as trans_uscita_business,
    count(case when tt.segno = '+' and tc.desc_tipo_conto = 'conto business' then 1 end) as trans_entrata_business,
    round(sum(case when tt.segno = '-' and tc.desc_tipo_conto = 'conto business' then tr.importo else 0 end), 2) as importo_uscita_business,
    round(sum(case when tt.segno = '+' and tc.desc_tipo_conto = 'conto business' then tr.importo else 0 end), 2) as importo_entrata_business,
    
    -- numero di transazioni in uscita ed in entrata e di importo per tipologia di conto (privati)

    count(case when tt.segno = '-' and tc.desc_tipo_conto = 'conto privati' then 1 end) as trans_uscita_privati,
    count(case when tt.segno = '+' and tc.desc_tipo_conto = 'conto privati' then 1 end) as trans_entrata_privati,
    round(sum(case when tt.segno = '-' and tc.desc_tipo_conto = 'conto privati' then tr.importo else 0 end), 2) as importo_uscita_privati,
    round(sum(case when tt.segno = '+' and tc.desc_tipo_conto = 'conto privati' then tr.importo else 0 end), 2) as importo_entrata_privati,
    
    -- numero di transazioni in uscita ed in entrata e di importo per tipologia di conto (famiglie)

    count(case when tt.segno = '-' and tc.desc_tipo_conto = 'conto famiglie' then 1 end) as trans_uscita_famiglie,
    count(case when tt.segno = '+' and tc.desc_tipo_conto = 'conto famiglie' then 1 end) as trans_entrata_famiglie,
    round(sum(case when tt.segno = '-' and tc.desc_tipo_conto = 'conto famiglie' then tr.importo else 0 end), 2) as importo_uscita_famiglie,
    round(sum(case when tt.segno = '+' and tc.desc_tipo_conto = 'conto famiglie' then tr.importo else 0 end), 2) as importo_entrata_famiglie

-- inner join per unire tutti i risultati finali

from banca.transazioni tr
inner join banca.tipo_transazione tt
    on tr.id_tipo_trans = tt.id_tipo_transazione
inner join banca.conto co
    on tr.id_conto = co.id_conto
inner join banca.cliente cl
    on co.id_cliente = cl.id_cliente
inner join banca.tipo_conto tc
    on co.id_tipo_conto = tc.id_tipo_conto
group by cl.id_cliente;


