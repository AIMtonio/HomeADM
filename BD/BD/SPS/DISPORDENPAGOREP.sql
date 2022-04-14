-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPORDENPAGOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPORDENPAGOREP`;
DELIMITER $$


CREATE PROCEDURE `DISPORDENPAGOREP`(
# =========================================================
# ----- SP PARA REPORTE DE ORDENES DE PAGO AL REALIZAR LA DISPERSION -------
# =========================================================
	Par_FolioOpe			INT(11),		-- Folio de la operación de dispersion
	Par_Institucion			INT(11),		-- Numero de la institucion
	Par_CtaBancaria			VARCHAR(50),	-- Cuenta bancaria
    Par_Referencia			VARCHAR(50),	-- referencia de la operacion
    Par_CuentaClabe			VARCHAR(50),	-- cuenta, clabe, numcheque, ...
    Par_FechaEnvio			DATE,			-- Fecha de envio de la operacion

	Par_EmpresaID			INT(11),		-- Parametros de auditoria
    Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore : BEGIN

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia 		CHAR(1);
    DECLARE Entero_Cero			INT(11);
    DECLARE Decimal_Cero		DECIMAL(12,2);
    DECLARE Cons_FormaOrdenPago	INT(11);
    DECLARE Entero_Treinta		INT(11);			-- Entero treinta

	-- Declaracion de Variables
    DECLARE	Cons_TipoOrdenPag	INT(11);

    DECLARE	Var_NumConvenio			VARCHAR(30);	-- Almacena el numero de convenio de la cuenta bancaria
    DECLARE	Var_DescConvenio		VARCHAR(100);	-- Descripcion del convenio de la cuenta bancaria
    DECLARE	Var_Monto				DECIMAL(12,2);	-- Monto de la operacion
    DECLARE	Var_MontoLetra			VARCHAR(200);	-- Monto en letra
    DECLARE	Var_CuentaClabeNum		VARCHAR(50);	-- Almacena Cuenta CLABE/Num. de Cheque /Num. Tarjeta/Cta Cheques/Ref. Orden Pago
    DECLARE	Var_Beneficiario		VARCHAR(200);	-- Nombre del beneficiario
    DECLARE	Var_Referencia			VARCHAR(200);	-- Referencia de la operacion
    DECLARE	Var_TipoMovDisp			INT(11);		-- Tipo de movimiento de la operacion
    DECLARE Var_NombreInstitucion	VARCHAR(200);	-- Nombre de la institucion
    DECLARE Var_CreditoID			VARCHAR(30);	-- ID del credito
    DECLARE Var_Concepto			VARCHAR(50);	-- Concepto de la orden de pago

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= ''; 		-- Cadena vacia
    SET Entero_Cero				:= 0;		-- Entero cero
    SET Decimal_Cero			:= 0.00;	-- DECIMAL cero
    SET Cons_FormaOrdenPago		:= 5;		-- Forma de pago de tipo "Orden de Pago" para dispersiones
    SET Entero_Treinta			:= 30;		-- Entero treinta



    SELECT NumConvenio,DescConvenio INTO Var_NumConvenio,Var_DescConvenio
		FROM CUENTASAHOTESO
        WHERE InstitucionID=Par_Institucion
        AND NumCtaInstit=Par_CtaBancaria;

    SELECT CAST(REPLACE(FORMAT(Monto, 2),',','') AS DECIMAL(14,2)), FUNCIONNUMLETRAS(Monto) , CuentaDestino, NombreBenefi,Referencia,
			CASE
				WHEN((TipoMovDIspID=700) OR (TipoMovDIspID=12) OR (TipoMovDIspID=2))THEN
					RPAD(REPLACE(SUBSTRING(Referencia,9),' ',''), 20, ' ')
				ELSE
					RPAD(CuentaDestino, 20, ' ')
			END,
            CASE
				WHEN((TipoMovDIspID=700) OR (TipoMovDIspID=12) OR (TipoMovDIspID=2))THEN
					IF ( LENGTH(CONCAT(REPLACE(Var_DescConvenio,' ',''),REPLACE(SUBSTRING(Referencia,9),' ',''))) <= Entero_Treinta,
						 RPAD(CONCAT(REPLACE(Var_DescConvenio,' ',''),REPLACE(SUBSTRING(Referencia,9),' ','')),Entero_Treinta,' '),
						 LEFT(CONCAT(REPLACE(Var_DescConvenio,' ',''),REPLACE(SUBSTRING(Referencia,9),' ','')),Entero_Treinta)
						)
				ELSE
					IF( LENGTH(CONCAT(REPLACE(Var_DescConvenio,' ',''),REPLACE(CuentaDestino,' ',''))) <= Entero_Treinta,
						RPAD(CONCAT(REPLACE(Var_DescConvenio,' ',''),REPLACE(CuentaDestino,' ','')),Entero_Treinta,' '),
						LEFT(CONCAT(REPLACE(Var_DescConvenio,' ',''),REPLACE(CuentaDestino,' ','')),Entero_Treinta)
						)
			END,
            TipoMovDIspID
		INTO Var_Monto ,Var_MontoLetra,Var_CuentaClabeNum,Var_Beneficiario,Var_Referencia,Var_CreditoID,Var_Concepto,
			Var_TipoMovDisp
		FROM DISPERSIONMOV
		WHERE DispersionID=Par_FolioOpe
			AND Referencia=Par_Referencia
			AND CuentaDestino=Par_CuentaClabe
            AND FechaEnvio=Par_FechaEnvio
            AND FormaPago=5
            AND Estatus='A';

    SELECT	UPPER(Inst.Nombre)
	INTO	Var_NombreInstitucion
	FROM PARAMETROSSIS Par
		INNER JOIN INSTITUCIONES Inst ON Par.InstitucionID = Inst.InstitucionID;

    -- OPERACIONES PARA SABER SI FUE UN DESEMBOLSO DE CREDITO
    IF (Var_TipoMovDisp=700) OR (Var_TipoMovDisp=12)
		OR (Var_TipoMovDisp=2)THEN
        SET Var_Beneficiario:= (SELECT cli.NombreCompleto
								FROM CREDITOS cre
									INNER JOIN CLIENTES cli ON cre.ClienteID=cli.ClienteID
								WHERE CreditoID=Var_CreditoID);
	END IF;

	SET Var_Monto 			:= IFNULL(Var_Monto,Decimal_Cero);
    SET Var_MontoLetra 		:= IFNULL(Var_MontoLetra,Cadena_Vacia);

    SET Var_CuentaClabeNum 	:= IFNULL(Var_CuentaClabeNum,Cadena_Vacia);
    SET Var_Beneficiario	:= IFNULL(Var_Beneficiario,Cadena_Vacia);
    SET Var_NumConvenio 	:= IFNULL(Var_NumConvenio,Cadena_Vacia);
    SET Var_DescConvenio 	:= IFNULL(Var_DescConvenio,Cadena_Vacia);

    IF(Var_MontoLetra<>Cadena_Vacia)THEN
		SET @longitud=LENGTH(Var_MontoLetra);
		SET Var_MontoLetra 	:= CONCAT('( ',SUBSTRING(Var_MontoLetra,1,@longitud-7),' Y ',SUBSTRING(Var_MontoLetra,@longitud-6),'M.N. )');
    END IF;

	SELECT 	Var_Monto AS Monto,
			Var_MontoLetra AS MontoLetras,
            Var_CuentaClabeNum AS cuentaClabeNum,
            Var_Beneficiario AS	Beneficiario,
            Var_NumConvenio AS NumConvenio,
            Var_Concepto AS DescConvenio,
            Var_NombreInstitucion AS NomInstitucion;

END TerminaStore$$