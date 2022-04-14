-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CHEQUESEMITIDOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CHEQUESEMITIDOSREP`;DELIMITER $$

CREATE PROCEDURE `CHEQUESEMITIDOSREP`(
# =========================================================
# ----- SP PARA GENERAR REPORTE DE CHEQUES EMITIDOS -------
# =========================================================
	Par_FechaInicio			DATE,			# Fecha de inicio
	Par_FechaFin			DATE,			# Fecha fin
	Par_Institucion			INT(2),			# Numero de la institucion
	Par_CtaBancaria			VARCHAR(20),	# Cuenta bancaria
    Par_TipoChequera		CHAR(2),		# Tipo Chequera- A-Ambas  P-Proforma E-Estandar
	Par_NumCheque			INT(11),		# Numero de cheque

	Par_Estatus				CHAR(1),		# Estatus E: Emitidos R: Reemplazados C: Cancelados P: Pagados O: Conciliados
	Par_Sucursal			INT(3),			# Numero de sucursal

	Par_EmpresaID			INT(11),		# Empresa ID
	Aud_Usuario				INT(11),		# Auditoria
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
	DECLARE TipCheq_Proforma	CHAR(1);
    DECLARE TipCheq_Estandar	CHAR(1);
    DECLARE TipCheq_Ambas		CHAR(1);

	-- Declaracion de Variables
	DECLARE	Var_Sentencia		VARCHAR(65535);

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= ''; 	-- Cadena vacia
    SET Entero_Cero				:= 0;
	SET TipCheq_Proforma		:= 'P';	-- Tipo chequera proforma
    SET TipCheq_Estandar		:= 'E';	-- Tipo chequera estandar
    SET TipCheq_Ambas			:= 'A';	-- Tipo Chequera Ambas


	-- Inicio de la sentencia para armar el reporte
	SET Var_Sentencia := 'SELECT CONCAT(cheque.InstitucionID,\' - \',ins.NombreCorto) AS Institucion,cheque.CuentaInstitucion AS CuentaBancaria,';
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN cheque.TipoChequera = "P" THEN "PROFORMA"');
    SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHEN cheque.TipoChequera = "E" THEN "CHEQUERA" END AS TipoChequera,');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' cheque.NumeroCheque,	cheque.FechaEmision,	cheque.Monto,');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' cheque.SucursalID,	usuario.Clave,	cheque.Concepto,	CASE WHEN cheque.ClienteID=NULL OR cheque.ClienteID= 0 THEN \'\' ELSE  cheque.ClienteID END AS ClienteID,	cheque.Beneficiario,');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' CASE WHEN cheque.Estatus = "E" THEN "EMITIDO"');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHEN cheque.Estatus = "R" THEN "REEMPLAZADO"');
    SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHEN cheque.Estatus = "C" THEN "CANCELADO"');
    SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHEN cheque.Estatus = "P" THEN "PAGADO"');
    SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHEN cheque.Estatus = "O" THEN "CONCILIADO" END AS Estatus,	cheque.Referencia');
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' FROM CHEQUESEMITIDOS cheque');
	SET Var_Sentencia := CONCAT(Var_Sentencia, '  INNER JOIN INSTITUCIONES ins on cheque.InstitucionID = ins.InstitucionID');
	SET Var_Sentencia := CONCAT(Var_Sentencia, '  INNER JOIN USUARIOS usuario on cheque.UsuarioID = usuario.UsuarioID');
	SET Var_Sentencia := CONCAT(Var_Sentencia, '  WHERE cheque.FechaEmision BETWEEN \'',Par_FechaInicio,'\' AND \'',Par_FechaFin,'\'');

	IF(Par_Institucion != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND cheque.InstitucionID = ',Par_Institucion);
	END IF;

	IF(Par_CtaBancaria != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND cheque.CuentaInstitucion = ',Par_CtaBancaria);
	END IF;

	IF(Par_TipoChequera != Cadena_Vacia) THEN
		IF(Par_TipoChequera = TipCheq_Ambas) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND (cheque.TipoChequera = "',TipCheq_Proforma,'" OR cheque.TipoChequera = "',TipCheq_Estandar,'")');

        ELSEIF(Par_TipoChequera = TipCheq_Estandar)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND cheque.TipoChequera = "',TipCheq_Estandar,'"');

        ELSEIF(Par_TipoChequera = TipCheq_Proforma)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND cheque.TipoChequera = "',TipCheq_Proforma,'"');
        END IF;
	END IF;

	IF(Par_Institucion != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND cheque.InstitucionID = ',Par_Institucion);
	END IF;

	IF(Par_NumCheque != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND cheque.NumeroCheque = ',Par_NumCheque);
	END IF;

	IF(IFNULL(Par_Estatus, Cadena_Vacia)) != Cadena_Vacia THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND cheque.Estatus = \'',Par_Estatus,'\'');
	END IF;

	IF(Par_Sucursal != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND cheque.SucursalID = ',Par_Sucursal);
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia,' ORDER BY cheque.InstitucionID, cheque.CuentaInstitucion, cheque.FechaEmision;' );

	SET @Sentencia	:= CONCAT(Var_Sentencia);

	PREPARE SPCHEQUESEMITIDOSREP FROM @Sentencia;

	EXECUTE SPCHEQUESEMITIDOSREP;


END TerminaStore$$