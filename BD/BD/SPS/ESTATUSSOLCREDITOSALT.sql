-- ESTATUSSOLCREDITOSALT

DELIMITER ;
DROP PROCEDURE IF EXISTS `ESTATUSSOLCREDITOSALT`;

DELIMITER $$
CREATE PROCEDURE `ESTATUSSOLCREDITOSALT`(
	Par_SolicitudCreditoID	BIGINT(20),		-- ID de la solicitud de credito
	Par_CreditoID			BIGINT(12),		-- ID de credito
	Par_Estatus				CHAR(1),		-- Estatus  de la solicitud de credito/credito
	Par_MotivoRechazoID     VARCHAR(50),    -- Id motivo rechazo
	Par_Comentario          VARCHAR(200),   -- Comentario del usuario que actualiza el estatus

	Par_Salida				CHAR(1),		-- Parametro Establece si requiere Salida
	INOUT Par_NumErr		INT(11),		-- Parametro INOUT para el Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro INOUT para la Descripcion del Error

	-- Parametros de Auditoria
	Aud_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables

	DECLARE		ConsecutivoID   BIGINT(20);      -- ID consecutvo
	DECLARE 	Var_Control		VARCHAR(100);	 -- Control de Retorno en pantalla
	DECLARE 	Var_Hora		TIME;	         -- Control de Retorno en pantalla
	DECLARE     Var_FechaSis    DATE;            -- Fecha del sistema
	DECLARE     Var_UltimoEstID INT(11);         -- Id del ultimo estatus
	DECLARE     Var_EstUltimo   CHAR(1);         -- Estatus del ultimo estado

	DECLARE     Var_SolicitudCreditoID  BIGINT(20);  -- Id de la solicitud de credito



	-- Declaracion de Constantes
	DECLARE		Cadena_Vacia	CHAR(1);	-- cadena vacia
	DECLARE		Fecha_Vacia		DATE;		-- fecha vacia
	DECLARE		Entero_Cero		INT(11);	-- entero en cero
	DECLARE 	Salida_SI 		CHAR(1);	-- Salida SI

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET Var_Control		:= '';
	SET Salida_SI		:= 'S';


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-ESTATUSSOLCREDITOSALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;
		-- Asignacion de Variables
		SET	ConsecutivoID	:= 0;

				-- Valida al usuario
		IF(IFNULL(Par_Estatus,Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'Estatus vacio.';
			SET Var_Control	:= 'estatus';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_SolicitudCreditoID,Entero_Cero)=Entero_Cero) THEN
			SET Var_SolicitudCreditoID:=(SELECT SolicitudCreditoID FROM CREDITOS  WHERE CreditoID=Par_CreditoID);
			SET Par_SolicitudCreditoID:=IFNULL(Var_SolicitudCreditoID,Entero_Cero);
		END IF;

		-- EVALUA EL ULTIMO ESTATUS
		SET Var_UltimoEstID := (SELECT MAX(EstatusSolCreID) FROM ESTATUSSOLCREDITOS WHERE SolicitudCreditoID=Par_SolicitudCreditoID);
		SET Var_UltimoEstID := IFNULL(Var_UltimoEstID,Entero_Cero);
		SET Var_EstUltimo   := (SELECT Estatus FROM ESTATUSSOLCREDITOS WHERE EstatusSolCreID = Var_UltimoEstID AND SolicitudCreditoID = Par_SolicitudCreditoID);

		IF(IFNULL(Var_EstUltimo,Cadena_Vacia)<>Par_Estatus)THEN
			SET ConsecutivoID := (SELECT IFNULL(MAX(EstatusSolCreID),Entero_Cero) + 1  FROM ESTATUSSOLCREDITOS);
			SET Var_Hora:= (SELECT DATE_FORMAT(NOW( ), "%H:%i:%S" ));
			SET Var_FechaSis:=(SELECT FechaSistema FROM PARAMETROSSIS);
			INSERT INTO ESTATUSSOLCREDITOS (
				EstatusSolCreID,	        SolicitudCreditoID,         CreditoID,		            Estatus,                        Fecha,
				HoraActualizacion,          MotivoRechazoID,            UsuarioAct,                 Comentario,                     EmpresaID,
				Usuario,					FechaActual,			    DireccionIP,	   	        ProgramaID,		                Sucursal,
				NumTransaccion		)
			VALUES(
				ConsecutivoID,				Par_SolicitudCreditoID,	    Par_CreditoID,              Par_Estatus,                    Var_FechaSis ,
				Var_Hora,                   Par_MotivoRechazoID,        Aud_Usuario,                Par_Comentario,                 Aud_EmpresaID,
				Aud_Usuario,		    	Aud_FechaActual,			Aud_DireccionIP,            Aud_ProgramaID,			        Aud_Sucursal,
				Aud_NumTransaccion	);
		END IF;

		SET	Par_NumErr := Entero_Cero;
		SET	Par_ErrMen := 'Estatus Grabado Exitosamente.';
		SET Var_Control:= 'solicitudCreditoID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				ConsecutivoID AS Consecutivo;
	END IF;

END TerminaStore$$