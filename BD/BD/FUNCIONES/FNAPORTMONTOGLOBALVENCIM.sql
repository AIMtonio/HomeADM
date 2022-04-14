-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNAPORTMONTOGLOBALVENCIM
DELIMITER ;
DROP FUNCTION IF EXISTS `FNAPORTMONTOGLOBALVENCIM`;

DELIMITER $$
CREATE FUNCTION `FNAPORTMONTOGLOBALVENCIM`(
	/* CALCULA EL MONTO GLOBAL DE LOS PRODUCTOS VIGENTES Y/O DEL GPO. FAMILIAR DE UN CLIENTE AL VENCIMIENTO. */
	Par_AportacionID	INT(11),	-- Aportacion ID
	Par_TipoAportID		INT(11),	-- TIPO DE APORTACION ID.
	Par_ClienteID		INT(11)		-- NÚMERO DEL CLIENTE.

) RETURNS DECIMAL(18,2)
    DETERMINISTIC
BEGIN
	-- DECLARACIÓN DE VARIABLES
	DECLARE Var_MontoGlobal			DECIMAL(18,2);	-- MONTO GLOBAL DEL CLIENTE Y SU GRUPO.
	DECLARE Var_TasaMontoGlobal		CHAR(1);		-- INDICA SI CALCULA LA TASA POR EL MONTO GLOBAL.
	DECLARE Var_IncluyeGpoFam		CHAR(1);		-- INDICA SI INCLUYE A SU GRUPO FAM EN EL MONTO.

	-- DECLARACIÓN DE CONSTANTES
	DECLARE Entero_Cero				INT(11);
	DECLARE Str_NO					CHAR(1);
	DECLARE Str_SI					CHAR(1);
	DECLARE EstatusVigente			CHAR(1);

	-- ASIGNACIÓN DE CONSTANTES
	SET Entero_Cero		:= 0;		-- Constante entero cero.
	SET Str_NO			:= 'N';		-- Constante no.
	SET Str_SI			:= 'S';		-- Constante si.
	SET EstatusVigente	:= 'N';		-- Estatus Vigente.

	SET Var_TasaMontoGlobal := (SELECT TasaMontoGlobal FROM TIPOSAPORTACIONES T
									WHERE T.TipoAportacionID = Par_TipoAportID);
	SET Var_IncluyeGpoFam := (SELECT IncluyeGpoFam FROM TIPOSAPORTACIONES T
									WHERE T.TipoAportacionID = Par_TipoAportID);

	IF(IFNULL(Var_TasaMontoGlobal,Str_NO)=Str_SI)THEN
		# MONTO DE LAS APORTACIONES VIGENTES DEL CLIENTE.
		SET Var_MontoGlobal :=
			(SELECT
				SUM(Monto)
			FROM APORTACIONES A
			WHERE A.ClienteID = Par_ClienteID
			  AND A.Estatus = EstatusVigente
			  AND A.AportacionID <> Par_AportacionID);

		IF(IFNULL(Var_IncluyeGpoFam,Str_NO)=Str_SI)THEN
			# MONTO DE LAS APORTACIONES VIGENTES DEL GRUPO FAMILIAR DEL CLIENTE.
			SET Var_MontoGlobal := IFNULL(Var_MontoGlobal, Entero_Cero) +
				(SELECT
					IFNULL(SUM(Monto),Entero_Cero)
				FROM APORTACIONES A
				INNER JOIN GRUPOSFAM G ON A.ClienteID=G.FamClienteID
				WHERE G.ClienteID = Par_ClienteID
				  AND A.Estatus = EstatusVigente
				  AND A.AportacionID <> Par_AportacionID);
		END IF;
	END IF;

	SET Var_MontoGlobal := IFNULL(Var_MontoGlobal, Entero_Cero);

	# RESULTADO DE LA CONSULTA.
	RETURN Var_MontoGlobal;
END$$