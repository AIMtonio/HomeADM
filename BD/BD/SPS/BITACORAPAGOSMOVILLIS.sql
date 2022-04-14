-- BITACORAPAGOSMOVILLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAPAGOSMOVILLIS`;
DELIMITER $$

CREATE PROCEDURE `BITACORAPAGOSMOVILLIS`(
	-- SP para listar las cobranza movil del grid
	Par_Fecha				DATE,					-- Paraemtro de fecha para generar el reporte.
	Par_Conciliado			CHAR(1),				-- Parametro que indica si se van a conciderar los registros conciliados.
	Par_Asesor				INT(11),				-- Parametro que indica el ID del usuario

	Par_NumLis				INT(11),				-- Numero de Lista
	
	Aud_EmpresaID			INT(11),				-- Parametro de auditoria
	Aud_Usuario				INT(11),				-- Parametro de auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal			INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Cons_SI				CHAR(1);			-- Constante SI
	DECLARE	Cons_NO				CHAR(1);			-- Constante NO
	DECLARE	OrigMov				CHAR(1);			-- Origen movil
	DECLARE	OrigSaf				CHAR(1);			-- Origen Safi
	DECLARE Lis_Principal   	INT(11);

	-- Declaracion de variables
	DECLARE Var_ClaUsuario		VARCHAR(40);

	-- Asignacion de constantes
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET Lis_Principal 		:= 1;		-- Lista para grid pagos conciliados
	SET Cons_SI 			:= 'S';
	SET Cons_NO 			:= 'N';
	SET OrigMov 			:= 'M';
	SET OrigSaf 			:= 'S';

	IF(Par_NumLis = Lis_Principal) THEN

		SET Par_Fecha 		:= IFNULL(Par_Fecha, Fecha_Vacia);
		SET Par_Conciliado 	:= IFNULL(Par_Conciliado, Cons_NO);
		SET Par_Asesor 		:= IFNULL(Par_Asesor, Entero_Cero);

		SET Var_ClaUsuario := (SELECT Clave FROM USUARIOS WHERE UsuarioID = Par_Asesor LIMIT 1);
		SET Var_ClaUsuario := IFNULL(Var_ClaUsuario, Cadena_Vacia);
		
		SELECT MOVIL.CreditoID, IFNULL(SAF.NumTransaccionBit, 0) AS Transaccion, MOVIL.Monto, MOVIL.FechaHoraOper AS FechaOperacion, MOVIL.ClaveProm,
			CASE WHEN SAF.NumTransaccionBit IS NOT NULL 
			       THEN Cons_SI
			       ELSE Cons_NO
			END AS Conciliado,
			OrigMov AS OrigenPago
		FROM BITACORAPAGOSMOVILDET AS MOVIL
		LEFT JOIN BITACORAPAGOSSAFI AS SAF ON MOVIL.DispositivoID = SAF.DispositivoID AND MOVIL.ClaveProm = SAF.ClaveProm AND MOVIL.SucursalID = SAF.SucursalID AND MOVIL.CreditoID = SAF.CreditoID AND MOVIL.FolioMovil = SAF.FolioMovil
		WHERE 	IF ((Par_Conciliado = Cons_NO), true, (SAF.NumTransaccionBit != 0))
			AND IF ((Par_Fecha	= Fecha_Vacia), true, (DATE(MOVIL.FechaHoraOper) = Par_Fecha))
			AND IF ((Var_ClaUsuario	= Cadena_Vacia), true, (MOVIL.ClaveProm = Var_ClaUsuario))
		UNION ALL
		SELECT SAFI.CreditoID, SAFI.NumTransaccionBit, SAFI.Monto, SAFI.FechaHoraOper AS FechaOperacion, SAFI.ClaveProm,
			Cons_NO AS Conciliado,
			OrigSaf AS OrigenPago
		FROM BITACORAPAGOSSAFI AS SAFI
		WHERE IF ((Par_Fecha = Fecha_Vacia), true, (DATE(SAFI.FechaHoraOper) = Par_Fecha))
			AND IF ((Var_ClaUsuario	= Cadena_Vacia), true, (SAFI.ClaveProm = Var_ClaUsuario))
		ORDER BY FechaOperacion ASC;

	END IF;

END TerminaStore$$