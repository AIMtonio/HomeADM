-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BENEFICIARIOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BENEFICIARIOREP`;DELIMITER $$

CREATE PROCEDURE `BENEFICIARIOREP`(
# ===================================================
# ---------- SP PARA OBTENER BENEFICIARIOS ----------
# ===================================================
	Par_CuentaAhoID			BIGINT(12),			-- ID de la cuenta de ahorro
	Par_NumBeneLis			INT(11), 			-- numero de beneficciarios de la lista 0 para todos

	Par_NumCon				TINYINT UNSIGNED, 	-- de cuentas, de inversiones, de cedes

	Par_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME, 			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15), 		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50), 		-- Parametro de Auditoria
	Aud_Sucursal			INT(11), 			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20) 			-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion Variables
	DECLARE Ben_Nombre 		VARCHAR(300);
	DECLARE Ben_Porcentaje 	VARCHAR(300);
    DECLARE VarCuentaID		BIGINT(12);

	-- Declaracion Constantes
	DECLARE Entero_Cero    	INT(11);
	DECLARE Decimal_Cero	DECIMAL(12,2);
	DECLARE Cadena_Vacia	CHAR(1);
    DECLARE TipoCedes		INT(11);
    DECLARE Const_Si		CHAR(3);
    DECLARE EstatusVige		CHAR(1);
	DECLARE PorcenCero      CHAR(5);
	DECLARE Porcentaje      CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero     	:= 0;
	SET Decimal_Cero		:= 0.00;
	SET Cadena_Vacia		:= '';
    SET TipoCedes			:= 2;
    SET Const_Si			:= 'S';
	SET EstatusVige			:= 'V';
	SET PorcenCero          := '0.00%';
	SET Porcentaje          := '%';

    IF(Par_NumCon != TipoCedes)THEN
		SELECT
			IFNULL(TRIM(CONCAT(CP.Titulo,' ', TRIM(CONCAT(CP.PrimerNombre,' ',CP.SegundoNombre,' ',CP.TercerNombre)),' ', CP.ApellidoPaterno,' ', CP.ApellidoMaterno)),Cadena_Vacia) AS Ben_Nombre,
						IFNULL(CONCAT(CP.Porcentaje,'%'), '0.00%') AS Ben_Porcentaje,
                        CP.Domicilio AS Ben_Domicilio, (DATE_FORMAT(CP.FechaNac, "%d/%m/%Y")) AS Ben_FechaNac
			FROM CUENTASPERSONA CP
			WHERE	CP.CuentaAhoID		= Par_CuentaAhoID
			AND 	CP.EsBeneficiario	= Const_Si
			LIMIT 	Par_NumBeneLis;
	END IF;



	IF(Par_NumCon = TipoCedes)THEN

		SELECT CuentaAhoID INTO VarCuentaID
		  FROM 	CEDES
		  WHERE	CedeID	= Par_CuentaAhoID;

		SET VarCuentaID := IFNULL(VarCuentaID,Entero_Cero);


		SELECT 	IFNULL(TRIM(CONCAT(cp.Titulo,' ', TRIM(CONCAT(cp.PrimerNombre,' ',cp.SegundoNombre,' ',cp.TercerNombre)),' ', cp.ApellidoPaterno,' ', cp.ApellidoMaterno)),'') AS Ben_Nombre,
				IFNULL(CONCAT(CAST(cp.Porcentaje AS CHAR),Porcentaje), PorcenCero) AS Ben_Porcentaje,
				tr.Descripcion AS Ben_Relacion
			FROM 	CUENTASPERSONA cp
					LEFT OUTER JOIN TIPORELACIONES tr ON cp.ParentescoID = tr.TipoRelacionID
			WHERE	CuentaAhoID		= VarCuentaID
			AND 	EsBeneficiario	= Const_Si
            AND 	EstatusRelacion	= EstatusVige;

	END IF;



END TerminaStore$$