-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCELASOLCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCELASOLCREPRO`;DELIMITER $$

CREATE PROCEDURE `CANCELASOLCREPRO`(
		/* SP para realizar la Cancelacion Automatica de las Solicitudes Individuales de Creditos */
		Par_Fecha				DATE,			# Fecha en la que se realiza la cancelacion

		Par_EmpresaID			INT(11),
		Aud_Usuario				INT(11),
		Aud_FechaActual			DATETIME,
		Aud_DireccionIP			VARCHAR(15),
		Aud_ProgramaID			VARCHAR(50),
		Aud_Sucursal			INT(11),
		Aud_NumTransaccion		BIGINT(20)

	)
TerminaStore: BEGIN

# Declaracion de Variables
DECLARE Var_DiasCancelaAutSolCre  	INT(11);        # Indica los dias parametrizados para realizar la cancelacion
DECLARE Var_FechaAutorizaSol        DATE;           # Indica la fecha de autorizacion para la cancelacion de las solicitudes de credito
DECLARE Var_FechaCancela			DATETIME;			# Fecha de cancelacion de la Solicitud de Credito

# Declaracion de Constantes
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE EstatusCancela  CHAR(1);
DECLARE TipoCancela     VARCHAR(100);
DECLARE EstSolAutor   	CHAR(1);
DECLARE EstAutorizado   CHAR(1);
DECLARE EstInactivo     CHAR(1);

# Asignacion de Constantes
SET	Cadena_Vacia	:= '';	       		# Entero Cero
SET	Fecha_Vacia		:= '1900-01-01';	# Fecha Vacia
SET	Entero_Cero		:= 0;               # Entero Cero
SET EstatusCancela  := 'C';			    # Estatus Solicitud: Cancelada
SET TipoCancela     := 'CANCELACION AUTOMATICA DE LA SOLICITUD';    #  Motivo de cancelacion de solicitudes de credito
SET EstSolAutor   	:= 'A';				# Estatus Solicitud: Autorizada
SET EstAutorizado   := 'A';				# Estatus Credito: Autorizado
SET EstInactivo   	:= 'I';             # Estatus Credito: Inactivo

SET Aud_FechaActual		:= NOW();
SET	Var_FechaCancela 	:= IFNULL(CONCAT(DATE(Par_Fecha)," ",CURRENT_TIME), Fecha_Vacia);

	# Obtener dias para la cancelacion de solicitudes de creditos
	SELECT DiasCancelaAutSolCre
			INTO Var_DiasCancelaAutSolCre
				FROM PARAMETROSSIS ;


	# Se realiza la actualizacion de las solicitudes de credito
		UPDATE SOLICITUDCREDITO Sol
			LEFT JOIN CREDITOS Cre	ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
										AND Cre.Estatus IN (EstInactivo,EstAutorizado)
			LEFT JOIN AMORTICREDITO Amo ON Amo.CreditoID = Cre.CreditoID
			SET	Sol.Estatus  = EstatusCancela,
				Cre.Estatus  = EstatusCancela,
				Amo.Estatus  = EstatusCancela,
				Sol.ComentarioEjecutivo = CONCAT(CASE WHEN IFNULL(ComentarioEjecutivo, Cadena_Vacia) = Cadena_Vacia
														THEN ""
														ELSE ""
												 END,
												 "---- ",TipoCancela," ----\n","--> ",
												 CAST(NOW() AS CHAR)," -- ",  "POR ", Var_DiasCancelaAutSolCre,
												 " DIAS TRANSCURRIDOS DESPUES DE SU AUTORIZACION", "\n\n",
												 LTRIM(RTRIM(IFNULL(Sol.ComentarioEjecutivo, Cadena_Vacia)))),
				Sol.ComentarioRech 		= CONCAT(CASE WHEN IFNULL(ComentarioEjecutivo, Cadena_Vacia) = Cadena_Vacia
														THEN ""
														ELSE ""
												 END,
												 "---- ",TipoCancela," ----\n", "--> ",
												 CAST(NOW() AS CHAR)," -- ", "POR ",Var_DiasCancelaAutSolCre,
												 " DIAS TRANSCURRIDOS DESPUES DE SU AUTORIZACION","\n\n",
												 LTRIM(RTRIM(IFNULL(Sol.ComentarioRech, Cadena_Vacia)))),
				Sol.FechaCancela = Var_FechaCancela,
				Sol.EmpresaID	= Par_EmpresaID,
				Sol.Usuario		= Aud_Usuario,
				Sol.FechaActual	= Aud_FechaActual,
				Sol.DireccionIP	= Aud_DireccionIP,
				Sol.ProgramaID	= Aud_ProgramaID,
				Sol.Sucursal	= Aud_Sucursal,
				Sol.NumTransaccion	= Aud_NumTransaccion,
				Cre.EmpresaID	= Par_EmpresaID,
				Cre.Usuario		= Aud_Usuario,
				Cre.FechaActual	= Aud_FechaActual,
				Cre.DireccionIP	= Aud_DireccionIP,
				Cre.ProgramaID	= Aud_ProgramaID,
				Cre.Sucursal	= Aud_Sucursal,
				Cre.NumTransaccion	= Aud_NumTransaccion,
				Amo.EmpresaID	= Par_EmpresaID,
				Amo.Usuario		= Aud_Usuario,
				Amo.FechaActual	= Aud_FechaActual,
				Amo.DireccionIP	= Aud_DireccionIP,
				Amo.ProgramaID	= Aud_ProgramaID,
				Amo.Sucursal	= Aud_Sucursal,
				Amo.NumTransaccion	= Aud_NumTransaccion

		WHERE DATEDIFF(Par_Fecha, Sol.FechaAutoriza) >= Var_DiasCancelaAutSolCre
				AND Sol.Estatus	= EstSolAutor
				AND IFNULL(Sol.GrupoID,Entero_Cero) = Entero_Cero;
END TerminaStore$$