-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ENVIOCORREOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ENVIOCORREOCON`;DELIMITER $$

CREATE PROCEDURE `ENVIOCORREOCON`(
/*SP para la consulta de correos*/
	Par_CorreoID			INT(11),				# Numero ID del Correo
	Par_Origen				CHAR(1),				# Origen: P.- PLD, B .- Banca Movil',
	Par_Asunto				VARCHAR(150),			# Asunto
	Par_Mensaje				TEXT,					# Cuerpo del mensaje de correo a enviar.',
	Par_Fecha				DATETIME,				# Fecha de Registro',
	Par_Estatus				CHAR(1),				#Estatus \\nE: Enviado\\nN: No enviado',
	Par_NumCon				TINYINT UNSIGNED,		# Numero de consulta

	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
		)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);				# Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;					# Fecha Vacia
	DECLARE	Entero_Cero				INT;					# Entero Cero
	DECLARE Cons_Si					CHAR(1);				# Constante SI
	DECLARE Cons_No					CHAR(1);				# Constante No
	DECLARE Cons_PendCorreoPLD		INT(11);				# Consulta Principal
	DECLARE Origen_PLD				CHAR(1);				# Origen PLD
	DECLARE PendientesEnviar		CHAR(1);				# Pendientes de Envio

	-- Asignacion de Constantes
	SET	Cadena_Vacia				:= '';				-- Cadena vacia
	SET	Fecha_Vacia					:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero					:= 0;				-- Entero Cero
	SET Cons_No						:= 'N';				-- Constante No
	SET Cons_Si						:= 'S';				-- Constante Si
	SET Cons_PendCorreoPLD			:= 1;				-- Consulta principal
	SET Origen_PLD					:= 'P';
	SET PendientesEnviar			:= 'N';				-- Pendientes a enviar

	/*
	Consulta 1: Correos pendientes a enviar de PLD
	*/
	IF(Par_NumCon = Cons_PendCorreoPLD) THEN
		SELECT
			COUNT(CorreoID) AS PendientesEnvio
		FROM ENVIOCORREO
			WHERE Origen = Origen_PLD
				AND Estatus = PendientesEnviar;
	END IF;

END TerminaStore$$