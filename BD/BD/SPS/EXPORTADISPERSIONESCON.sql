DELIMITER ;

DROP PROCEDURE IF EXISTS EXPORTADISPERSIONESCON;

DELIMITER $$

CREATE PROCEDURE `EXPORTADISPERSIONESCON`(
# ======================================================
# -------SP PARA EXPORTAR ARCHIVOS DE DISPERSION--------
# ======================================================
	Par_NumTransaccion		BIGINT(20),			-- Numero de Transaccion
    Par_NumConsulta       	TINYINT UNSIGNED,	-- Numero de Consulta

	Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la Empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la Transaccion
)
TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE Var_NumInstitucion		VARCHAR(20);
	DECLARE Var_NumCtaInstitucion	VARCHAR(200);
	DECLARE Var_FechaSistema		DATE;

	-- Declaracion de Constantes
	DECLARE Entero_Cero  		INT(11);
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE SalidaNO        	CHAR(1);
	DECLARE Con_ExportaInter 	INT(11);
    DECLARE LlaveNumCtaInstit	VARCHAR(50);

	DECLARE TipoCtaTarjeta		INT(11);
	DECLARE TipoCtaClabe		INT(11);

	-- Asignacion de Constantes
	SET Entero_Cero  			:= 0;		-- Entero Cero
	SET Cadena_Vacia    		:= '';		-- Cadena Vacia
	SET SalidaNO        		:= 'N';		-- Salida: NO
	SET Con_ExportaInter		:= 1;		-- Exporta Layout Interbancario
    SET LlaveNumCtaInstit		:= 'NumCtaInstitucion';	-- Llave Numero de Cuenta de la Institucion Bancaria

    SET TipoCtaTarjeta			:= 3;		-- Tipo Cuenta SPEI TARJETA DE DEBITO corresponde de la tabla TIPOSCUENTASPEI
    SET TipoCtaClabe			:= 40;		-- Tipo Cuenta CLABE corresponde de la tabla TIPOSCUENTASPEI

    -- Se obtiene la Fecha del Sistema
	SET Var_FechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS);

	IF(Par_NumConsulta = Con_ExportaInter) THEN
		SET Var_NumCtaInstitucion 	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = LlaveNumCtaInstit);

        SET Var_NumCtaInstitucion	:=IFNULL(Var_NumCtaInstitucion,Cadena_Vacia);

        SELECT
			AB.Clabe AS CuentaDestino,
			Var_NumCtaInstitucion AS NumCtaInstit,
            AB.MontoDispersion AS Monto,
            AB.Beneficiario AS NombreBenefi,
            INS.Folio AS Folio,
            'PAGO DE APORTACION' AS Descripcion,
            CONCAT(DATE_FORMAT(Var_FechaSistema, '%d%m%y'),'0') AS Referencia,
            LPAD(CT.TipoCuentaSpei,2,'0') AS TipoCuentaSpei
		FROM HISAPORTBENEFICIARIOS AB
			INNER JOIN APORTACIONES AP ON AB.AportacionID = AP.AportacionID
			INNER JOIN CUENTASTRANSFER CT ON AP.ClienteID = CT.ClienteID AND AB.CuentaTranID = CT.CuentaTranID
            INNER JOIN INSTITUCIONES INS ON INS.ClaveParticipaSpei = CT.InstitucionID
		WHERE AB.NumTransaccion = Par_NumTransaccion
        AND CT.TipoCuentaSpei IN(TipoCtaTarjeta,TipoCtaClabe);

	END IF;

END TerminaStore$$