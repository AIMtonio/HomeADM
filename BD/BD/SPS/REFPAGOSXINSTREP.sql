-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REFPAGOSXINSTREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REFPAGOSXINSTREP`;
DELIMITER $$


CREATE PROCEDURE `REFPAGOSXINSTREP`(
# =====================================================================================
# ------- STORED PARA REPORTE DE REFERENCIAS DE PAGO POR INSTRUMENTO 	---------
# =====================================================================================
    Par_TipoCanalID			INT(11), 		-- ID del tipo de canal CUENTAS, CREDITOS, TARJETA
	Par_InstrumentoID		BIGINT(20), 	-- ID del instrumento (CuentaAhoID, CreditoID, TARJETA).
	Par_ClienteID 			INT(11),		-- ID del cliente

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES

    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_Producto		VARCHAR(150);		-- Variable de Producto
    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno

	DECLARE Con_Cuenta			INT(11);			-- Constante para el valor de Cuenta
	DECLARE Con_Credito			INT(11);			-- Constante para el valor de Credito
	DECLARE Con_Tarjeta			INT(11);			-- Constante para el valor de Tarjeta
    -- ASIGNACIŃ DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;

	SET Con_Credito				:= 1;
	SET Con_Cuenta				:= 2;
	SET Con_Tarjeta				:= 3;

	IF Par_TipoCanalID = Con_Cuenta THEN
		SELECT CONCAT(TIP.TipoCuentaID,"-",TIP.Descripcion) INTO Var_Producto FROM CUENTASAHO CUE
		INNER JOIN TIPOSCUENTAS TIP ON CUE.TipoCuentaID = TIP.TipoCuentaID
		WHERE CUE.CuentaAhoID = Par_InstrumentoID;
	END IF;

	IF Par_TipoCanalID = Con_Credito THEN
		SELECT CONCAT(PRO.ProducCreditoID,"-",PRO.Descripcion) INTO Var_Producto FROM CREDITOS CRE
		INNER JOIN PRODUCTOSCREDITO PRO ON CRE.ProductoCreditoID = PRO.ProducCreditoID
		WHERE CRE.CreditoID = Par_InstrumentoID;
	END IF;

	IF Par_TipoCanalID = Con_Tarjeta THEN
		SELECT CONCAT(Tar.TarjetaDebID,"-",Tip.Descripcion) INTO Var_Producto FROM TARJETADEBITO Tar
		INNER JOIN TIPOTARJETADEB Tip ON Tip.TipoTarjetaDebID=Tar.TipoTarjetaDebID
		WHERE Tar.TarjetaDebID = Par_InstrumentoID;
	END IF;


	SELECT 	REF.InstitucionID,	REF.NombInstitucion, 	REF.Referencia, INS.RutaLogo, REF.TipoCanalID,
            INS.NombreCorto, IFNULL(INS.NumConvenio,Cadena_Vacia) NumConvenio, IFNULL(INS.ConvenioInter,Cadena_Vacia) ConvenioInter,
            IFNULL(Var_Producto,Cadena_Vacia) AS Producto
	FROM REFPAGOSXINST REF
		INNER JOIN INSTITUCIONES INS
			ON REF.InstitucionID = INS.InstitucionID
	WHERE REF.TipoCanalID = IFNULL(Par_TipoCanalID,Entero_Cero)
		AND REF.InstrumentoID = IFNULL(Par_InstrumentoID,Entero_Cero);


END TerminaStore$$
