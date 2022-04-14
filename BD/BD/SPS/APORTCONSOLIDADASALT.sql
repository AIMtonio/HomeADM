

-- APORTCONSOLIDADASALT --

DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTCONSOLIDADASALT`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `APORTCONSOLIDADASALT`(
/* SP DE ALTA DE APORTACIONES CONSOLIDADAS */
	Par_AportacionID			INT(11),		-- Número de la Aportación a Consolidar.
	Par_AportConsID				INT(11),		-- Número de la Aportación Consolidada.
	Par_FechaVencimiento		DATE,			-- Fecha de Vencimiento de la Aportación Consolidada.
	Par_Capital					DECIMAL(18,2),	-- Monto Capital de la Aportación Consolidada.
	Par_Interes					DECIMAL(18,2),	-- Interés Generado de la Aportación Consolidada.

	Par_ISR						DECIMAL(18,2),	-- Interés a Retener de la Aportación Consolidada.
	Par_TotalAport				DECIMAL(18,2),	-- Monto Total de la Aportación Consolidada. Monto + Interes - ISR
	Par_Reinvertir				CHAR(3),		-- Tipo de Reinversión de la Aportación Consolidada. Elegido desde Condiciones de Vencimiento. C: Sólo Capital CI: Capital + Intereses
	Par_TotalCons				DECIMAL(18,2),	-- Monto Toal a Reinvertir de la Aportación Consolidada. De acuerdo al campo Reinvertir.
	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No

	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,

	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control			CHAR(15);		-- Nombre del control en pantalla.
DECLARE Var_MontoTotal		DECIMAL(18,2);	-- Monto Total de la Dispersión.
DECLARE Var_AportID			INT(11);		-- Numero de Aportacion para consolidación.

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		VARCHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE	Cons_SI				CHAR(1);
DECLARE	Cons_NO				CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia.
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia.
SET Entero_Cero			:= 0;				-- Entero Cero.
SET	Cons_SI				:= 'S';				-- Constante Si.
SET	Cons_NO				:= 'N'; 			-- Constante No.
SET Aud_FechaActual 	:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-APORTCONSOLIDADASALT');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(IFNULL(Par_Reinvertir, Cadena_Vacia)=Cadena_Vacia)THEN
		SET	Par_NumErr := 1;
		SET	Par_ErrMen := CONCAT('El Tipo de Reinversion esta Vacio.');
		SET Var_Control:= 'aportacionID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TotalCons, Entero_Cero)=Entero_Cero)THEN
		SET	Par_NumErr := 2;
		SET	Par_ErrMen := CONCAT('El Monto Total a Consolidar esta Vacio.');
		SET Var_Control:= 'aportacionID' ;
		LEAVE ManejoErrores;
	END IF;

	SET Var_AportID := (SELECT AportacionID FROM APORTCONSOLIDADAS WHERE AportacionID != Par_AportacionID AND AportConsID = Par_AportConsID);
	SET Var_AportID := IFNULL(Var_AportID,Entero_Cero);

	IF(Var_AportID != Entero_Cero)THEN
		SET	Par_NumErr := 3;
		SET	Par_ErrMen := CONCAT('La Aportacion a Consolidar ', Par_AportConsID,
							' Se Encuentra en el Grupo de la Aportacion ',Var_AportID,'.');
		SET Var_Control:= 'aportacionID' ;
		LEAVE ManejoErrores;
	END IF;

	INSERT INTO APORTCONSOLIDADAS(
		AportacionID,		AportConsID,		FechaVencimiento,		Capital,			Interes,
		ISR,				TotalAport,			Reinvertir,				TotalCons,			EmpresaID,
		UsuarioID,			FechaActual,		DireccionIP,			ProgramaID,			Sucursal,
		NumTransaccion)
	VALUES(
		Par_AportacionID,	Par_AportConsID,	Par_FechaVencimiento,	Par_Capital,		Par_Interes,
		Par_ISR,			Par_TotalAport,		Par_Reinvertir,			Par_TotalCons,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	# SE ACTUALIZA SI CONSOLIDA
	UPDATE APORTACIONES
	SET
		ConsolidarSaldos = IF(Par_AportacionID = Par_AportConsID, 'G', 'I'),
		ConCondiciones = IF(IF(Par_AportacionID = Par_AportConsID, 'G', 'I')='I',Cons_NO,Cons_SI)
	WHERE AportacionID = Par_AportConsID;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := CONCAT('Consolidacion Grabada Exitosamente.');
	SET Var_Control:= 'aportConsolID' ;

END ManejoErrores;

IF (Par_Salida = Cons_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Cadena_Vacia AS Consecutivo;
END IF;

END TerminaStore$$