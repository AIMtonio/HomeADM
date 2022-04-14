-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROTECORDENPAGOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROTECORDENPAGOLIS`;
DELIMITER $$


CREATE PROCEDURE `PROTECORDENPAGOLIS`(
-- =========================================================
-- ----- SP PARA ARCHIVO DE PROTECCION DE ORDENES DE PAGO --
-- =========================================================
	Par_FolioOpe		INT(11),		-- Folio de la operación de dispersion
	Par_Institucion		INT(11),		-- Numero de la institucion
	Par_CtaIstitucion	VARCHAR(50),	-- Cuenta bancaria
    Par_NumLista		INT(11),		-- Tipo de lista, 1:encabezado/ 2:Detalle/ 3:sumario

	Par_EmpresaID		INT,			-- Parametros de auditoria
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT

	)

TerminaStore: BEGIN
	-- Declaracion de constantes
    DECLARE	Cons_Encabezado		INT(11);
    DECLARE	Cons_Detalle		INT(11);
    DECLARE	Cons_Sumario		INT(11);
    DECLARE Entero_Treinta		INT(11);		-- Entero treinta
    DECLARE LimpiaAlfabetico	VARCHAR(2);		-- Limpieza de texto que contiene solo letras

	-- Declaracion de Variables
	DECLARE	Var_NumRegistros	VARCHAR(5);		-- Total de dispersiones autorizadas
    DECLARE	Var_MontoTotal		DECIMAL(12,2);	-- Monto total de las dispersiones autorizadas en el folio
    DECLARE	Var_Monto			DECIMAL(12,2);	-- Monto de la operación

    -- asignacion de constantes
    SET	Cons_Encabezado			:= 1;			-- Lista para el encabezado
    SET	Cons_Detalle			:= 2;			-- Lista para el detalle
    SET	Cons_Sumario			:= 3;			-- Lista para el sumario
    SET Entero_Treinta			:= 30;			-- Entero treinta
    SET LimpiaAlfabetico		:= 'A';

    -- lista para encabezado de ordenes de pago
    IF(Par_NumLista=Cons_Encabezado)THEN
		SELECT 'H' AS Encabezado, -- 1 QUEMADO
				LPAD(ctas.NumConvenio,9,'0') AS NumConvenio, -- 2
				LPAD(dis.FechaEnvio,10,'') AS FechaEnvio, -- 3
				RPAD(CONCAT('CREDITOS',REPLACE(LPAD(dis.FechaEnvio,10,''),'-','')),30,' ') AS Concepto, -- 4
				'00' AS Confirmacion, -- 5 QUEMADO
				'   ' AS Canal,-- 6 QUEMADO
				'                                   ' AS CuentaCargo,-- 7 QUEMADO
				'                      ' AS Campo1,-- 8 QUEMADO
				'   'AS Divisa,-- 9 QUEMADO
				'                                                                                                                                             ' AS Campo2
			FROM DISPERSIONMOV dis,
				CUENTASAHOTESO ctas
			WHERE dis.DispersionID=Par_FolioOpe
				AND dis.FormaPago=5
				AND ctas.InstitucionID=Par_Institucion
				AND ctas.NumCtaInstit=Par_CtaIstitucion
			LIMIT 1;
    END IF;


    -- lista para detalle de ordenes de pago
    IF(Par_NumLista=Cons_Detalle)THEN
		DROP TABLE IF EXISTS TMPDISPORDENPAGOCRE;
		CREATE TABLE TMPDISPORDENPAGOCRE(
			Detalle 		CHAR(1),		-- Detalle: 'D'
			Alta			CHAR(1),		-- Alta: 'A'
			CtaNum			VARCHAR(50),	-- Contenido del campo cuenta/numCheque/clabe
			Concepto		VARCHAR(30),	-- Concepto
			PagoVentanilla	CHAR(3),		-- Pago de Ventanilla: 'PDV'
			CodPagoVent		INT(11),		-- Codigo de pago en ventanilla: 1
			NoPagosInter	VARCHAR(50),	-- Pagos de interes
			Referencia		VARCHAR(40),	-- Referencia
			Beneficiario	VARCHAR(40),	-- Nombre del Beneficiario
			Identificacion	INT(11),		-- Identificacion: 2
			Divisa			CHAR(3),		-- Divisa: 'MXP'
			Monto			VARCHAR(40),	-- Monto del movimiento
			Confirmacion	CHAR(2),		-- Confirmacion: 00
			CorreoCel		VARCHAR(50),	-- Correo o celular
			FechaDisp		VARCHAR(50),	-- Fecha de la dispersion
			FechaVen		VARCHAR(50),	-- Fecha de vencimiento del credito
			Estatus			CHAR(5),		-- Estatus
			DescEstatus		VARCHAR(50),	-- Descripcion del estatus
			TipoMovDisp		INT(11),		-- Tipo movimiento dispersion
			FormaPago		INT(11),		-- Forma de pago de la dispersion
            MontoReal		DECIMAL(14,2)			-- Monto REAL de la dispersion en formato DECIMAL
		);

		INSERT INTO TMPDISPORDENPAGOCRE
		SELECT
			'D', -- 1	QUEMADO
			'A', -- 2	QUEMADO
			CASE
				WHEN((TipoMovDIspID=700 AND FormaPago=5) OR (TipoMovDIspID=12 AND FormaPago=5) OR (TipoMovDIspID=2 AND FormaPago=5))THEN
					RPAD(REPLACE(SUBSTRING(Referencia,9),' ',''), 20, ' ')
				ELSE
					RPAD(CuentaDestino, 20, ' ')
			END,  -- 3
			CASE
				WHEN((TipoMovDIspID=700 AND FormaPago=5) OR (TipoMovDIspID=12 AND FormaPago=5) OR (TipoMovDIspID=2 AND FormaPago=5))THEN
					IF( LENGTH(CONCAT(REPLACE(DescConvenio,' ',''),REPLACE(SUBSTRING(Referencia,9),' ',''))) <= Entero_Treinta,
						RPAD(CONCAT(REPLACE(DescConvenio,' ',''),REPLACE(SUBSTRING(Referencia,9),' ','')),Entero_Treinta,' '),
						LEFT(CONCAT(REPLACE(DescConvenio,' ',''),REPLACE(SUBSTRING(Referencia,9),' ','')),Entero_Treinta)
						)
				ELSE
					IF( LENGTH(CONCAT(REPLACE(DescConvenio,' ',''),REPLACE(CuentaDestino,' ',''))) <= Entero_Treinta,
						RPAD(CONCAT(REPLACE(DescConvenio,' ',''),REPLACE(CuentaDestino,' ','')),Entero_Treinta,' '),
						LEFT(CONCAT(REPLACE(DescConvenio,' ',''),REPLACE(CuentaDestino,' ','')),Entero_Treinta)
						)
			END, -- 4
			'PDV', -- 5 QUEMADO
			1, -- 6 QUEMADO
			'       ',-- 7	QUEMADO
			RPAD(Referencia, 40, ' '),-- 8
			RPAD(FNLIMPIACARACTBUROCRED(NombreBenefi,LimpiaAlfabetico), 40, ' '),-- 9
			2,-- 10	QUEMADO
			'MXP',-- 11	QUEMADO
			LPAD(REPLACE(REPLACE(Monto,'.',''),' ',''),15,'0'),-- 12
			'00',-- 13 QUEMADO
			'                                        ',-- 14 QUEMADO
			LPAD(FechaEnvio,10,''),-- 15
			LPAD(CONVERT(DATE_ADD(FechaEnvio, INTERVAL 1 MONTH ), DATE),10,''),-- 16
			'  ',-- 17 QUEMADO
			'                              ',-- 18 QUEMADO
			dis.TipoMovDIspID,	-- -- Campo de apoyo para actualizar la fecha
			dis.FormaPago, -- Campo de apoyo para actualizar la fecha
            CAST(REPLACE(FORMAT(Monto, 2),',','') AS DECIMAL(14,2))
			FROM DISPERSIONMOV dis,
				CUENTASAHOTESO ctas
			WHERE dis.DispersionID=Par_FolioOpe
				AND dis.FormaPago=5
                AND dis.Estatus='A'
				AND ctas.InstitucionID=Par_Institucion
				AND ctas.NumCtaInstit=Par_CtaIstitucion;

			-- ACTUALIZAR LA FECHA DE VENCIMIENTO SI ES UN DESEMBOLSO DE CREDITO
			UPDATE TMPDISPORDENPAGOCRE tmp
			INNER JOIN CREDITOS cre ON RTRIM(tmp.ctaNum)=cre.CreditoID
			SET tmp.FechaVen=
				CASE
					WHEN ((tmp.TipoMovDisp=700 AND tmp.FormaPago=5)
						OR (tmp.TipoMovDisp=12 AND tmp.FormaPago=5)
						OR (tmp.TipoMovDisp=2 AND tmp.FormaPago=5))THEN
							LPAD(cre.FechaVencimien,10,'')
				END;


			SELECT
				Detalle,
				Alta,
				ctaNum,
				concepto,
				PagoVentanilla,
				CodPagoVent,
				NoPagosInter,
				Referencia,
				Beneficiario,
				Identificacion,
				Divisa,
				REPLACE(Monto,',','') AS Monto,
				Confirmacion,
				CorreoCel,
				FechaDisp,
				FechaVen,
				CASE WHEN Estatus='' THEN '  ' END AS Estatus,
				DescEstatus
			FROM TMPDISPORDENPAGOCRE;
    END IF;

    -- lista para sumario de ordenes de pago
    IF(Par_NumLista=Cons_Sumario)THEN

        SET Var_NumRegistros := (SELECT COUNT(*) FROM TMPDISPORDENPAGOCRE);
        SET Var_MontoTotal 	 := (SELECT SUM(Montoreal) FROM TMPDISPORDENPAGOCRE);

		SELECT 'T' AS Encabezado, -- 1
				LPAD(Var_NumRegistros,5,'0') AS TotalRegistros, -- 2
				LPAD(REPLACE(REPLACE(REPLACE(FORMAT(Var_MontoTotal, 2),'.',''),',',''),' ',''),15,'0') AS MontoTotal, -- 3
				'00000' AS CincoCeros, -- 4 QUEMADO			**** Estos datos se repiten hasta la fila 13
                '000000000000000' AS QuinceCeros, -- 5 QUEMADO 	Se van intercalando 5 ceros y 15 ceros ****
                '0000' AS CuatroCeros, -- 14 QUEMADO			**** Estos datos se repiten hasta la fila 33
                '000000000' AS NueveCeros, -- 15 QUEMADO 	Se van intercalando 4 ceros y 9 ceros ****
                '     ' AS CincoEspacios -- 34 QUEMADO
                ;
    END IF;

END TerminaStore$$