CREATE TABLE tb_estacionamento 
    ( nm_nome_fantasia VARCHAR (50), vl_preco REAL, vl_lat REAL, vl_lng REAL );

INSERT INTO tb_estacionamento 
    ( nm_nome_fantasia, vl_preco, vl_lat, vl_lng )
VALUES 
    ( 'Mercado municipal', 15.00, -23.541634, -46.629107 ),
    ( 'Metro sao Bento', 10.00, -23.544385, -46.634128 );

CREATE OR REPLACE FUNCTION calc_dist(nLat1 real, nLon1 real, nLat2 real, nLon2 real) RETURNS REAL AS $$
    DECLARE 
		nDLat real = 0;
		nDLon real = 0;
        nA real;
    BEGIN
    	nDLat = ((nLat2 - nLat1) * pi()) / 180;
		nDLon = ((nLon2 - nLon1) * pi()) / 180;
    
    	nA = power(sin(nDLat / 2), 2) + cos((nLat1 * pi()) / 180)
            * cos((nLat2 * pi()) / 180) * power(sin(nDLon / 2), 2);
            
        RETURN 6371 * 2 * atan2(sqrt(nA), sqrt(1 - nA));
END;
$$ LANGUAGE plpgsql;

/*
DO $$
    BEGIN  
    CREATE TEMP TABLE tmp_table ON COMMIT DROP AS
        SELECT 
            nm_nome_fantasia, vl_preco,
            calc_dist(
                -23.497141, -46.154277, 	-- posição atual
                vl_lat, vl_lng				-- destino
            ) distancia_km					-- alias
		FROM tb_estacionamento;
END $$;

SELECT * FROM tmp_table
WHERE distancia_km <= 1.0;
*/

SELECT 
    nm_nome_fantasia, vl_preco,
    calc_dist(
        -22.909198, -47.062522, 	-- posição atual
        vl_lat, vl_lng				-- destino
    ) distancia_km					-- alias
FROM tb_estacionamento;


