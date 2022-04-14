-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BEPAGOSNOMINACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BEPAGOSNOMINACT`;

DELIMITER $$
CREATE PROCEDURE `BEPAGOSNOMINACT`(
	-- Store Procedure para la actualizacion de los pagos via nomina
	-- Modulo Creditos Nomina --> Procesos --> Aplicacion de Pagos de Credito via Nomina
	Par_FolioNominaID		INT(11),		-- Numero de Folio de Nomina
	Par_FolioCargaID		INT(11),		-- Numero de Folio de Carga
	Par_CreditoID			BIGINT(12),		-- Numero de Credito
	Par_ClienteID			INT(11),		-- Numero de Cliente
	Par_MontoPagos			DECIMAL(12,2),	-- Monto de Pago

	Par_Estatus				CHAR(1),		-- Estatus
	Par_MotivoCancela		VARCHAR(400),	-- Motivo de Cancelacion
	Par_TipoAct				INT(11),		-- Tipo de Actualizacion

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Parametro de Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro de Mensaje de Error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Actualizaciones
	DECLARE Act_Cancelado		INT(11);	-- Actualizacion a cancelado

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(50);-- Control de Retorno a pantalla
	DECLARE Var_EstatusCarga	INT(11);	-- Estatus del Folio de Carga
	DECLARE Var_FolioCarga		INT(11);	-- Numero de Folio de Carga
	DECLARE Var_FechaSistama	DATE;		-- Fecha del Sistema

	-- Declaracion de Constantes
	DECLARE Con_PorAplicar		CHAR(1);	-- Constantes por Aplicar
	DECLARE Con_Procesado		CHAR(1);	-- Constantes Procesado
	DECLARE Est_Cancelado		CHAR(1);	-- Constantes Estatus Cancelado
	DECLARE SalidaSI			CHAR(1);	-- Constantes Salida SI
	DECLARE Entero_Cero			INT(11);	-- Constantes Entero Cero

	-- Declaracion de Actualizaciones
	SET Act_Cancelado			:= 1 ;

	-- Declaracion de Constantes
	SET Con_PorAplicar			:= 'P';
	SET Con_Procesado			:= 'P';
	SET Est_Cancelado			:= 'C';
	SET SalidaSI				:= 'S';
	SET Entero_Cero				:=  0;

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr 	= 999;
			SET Par_ErrMen 	= CONCAT('El SAFI ha tenido un problema al concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-BEPAGOSNOMINACT');
			SET Var_Control = 'sqlException' ;
		END;

		SELECT FechaSistema
		INTO Var_FechaSistama
		FROM PARAMETROSSIS
		LIMIT 1;

		IF( Par_TipoAct = Act_Cancelado ) THEN

			UPDATE BEPAGOSNOMINA SET
				MontoAplicado = Entero_Cero,
				Estatus = Est_Cancelado,
				MotivoCancela = UPPER(Par_MotivoCancela),
				FechaAplicacion = Var_FechaSistama
			WHERE FolioNominaID = Par_FolioNominaID;

			SET Var_FolioCarga  := ( SELECT FolioCargaID
									 FROM BEPAGOSNOMINA
									 WHERE FolioNominaID = Par_FolioNominaID);


			SET Var_EstatusCarga := (SELECT COUNT(Estatus)
									 FROM BEPAGOSNOMINA
									 WHERE Estatus = Con_PorAplicar
									   AND FolioCargaID = Var_FolioCarga);

			IF( Var_EstatusCarga = Entero_Cero ) THEN
				UPDATE BECARGAPAGNOMINA SET
					Estatus = Con_Procesado,
					FechaApliPago = Var_FechaSistama
				WHERE FolioCargaID = Var_FolioCarga;
			END IF;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Pagos Cancelados Correctamente';
			SET Var_Control := 'FolioNominaID';

		END IF;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$