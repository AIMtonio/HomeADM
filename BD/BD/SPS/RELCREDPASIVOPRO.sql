-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELCREDPASIVOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS RELCREDPASIVOPRO;

DELIMITER $$
CREATE PROCEDURE RELCREDPASIVOPRO(
	-- Stored Procedure para dar de alta el cambio de fondeo de credito
	Par_CreditoID						BIGINT(12),		-- ID del credito de activo (Une con tabla CREDITOS).
	Par_CreditoFondeoID					BIGINT(20),		-- ID de Credito de Pasivo (Une con tabla CREDITOFONDEO).

	Par_Salida							CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr					INT(11),		-- Parametro de Numero de Error
	INOUT Par_ErrMen					VARCHAR(400),	-- Parametro de Mensaje de Error

	-- Parametros de Auditoria
	Aud_EmpresaID						INT(11),		-- ID de la Empresa
	Aud_Usuario							INT(11),		-- ID del Usuario que creo el Registro
	Aud_FechaActual						DATETIME,		-- Fecha Actual de la creacion del Registro
	Aud_DireccionIP						VARCHAR(15),	-- Direccion IP de la computadora
	Aud_ProgramaID						VARCHAR(50),	-- Identificador del Programa
	Aud_Sucursal						INT(11),		-- Identificador de la Sucursal
	Aud_NumTransaccion					BIGINT(20)		-- Numero de Transaccion
)TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE	Entero_Cero					INT(11);		-- Entero vacio
	DECLARE Cadena_Vacia				CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia					DATETIME;		-- Fecha Vacia
	DECLARE SalidaSI					CHAR(1);		-- Salida Si
	DECLARE Cons_SI						CHAR(1);		-- Salida Si
	DECLARE Cons_NO						CHAR(1);		-- Salida Si
	DECLARE Est_RelacionActiva			CHAR(1);		-- Estatus de la relacion entre el credito Activo y pasivo (A= Activa)
	DECLARE Est_RelacionVencida			CHAR(1);		-- Estatus de la relacion entre el credito Activo y pasivo (V= Vencida)

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);	-- Variable de Control SQL
	DECLARE	Var_Consecutivo				BIGINT(20);		-- Variable Consecutivo
	DECLARE Var_CreditoID				BIGINT(12);		-- Variable del numero del crédito
	DECLARE Var_CreditoFondeoID			INT(11);		-- Variable del Credito pasivo FOndeo
	DECLARE Var_RelCreditoPasivoID		BIGINT(12);		-- Variable del consecutivo del de la tabla RELCREDPASIVO
	DECLARE Var_CounRelCredPasID		INT(11);		-- Variable contador

	-- Asignacion de Constantes
	SET Entero_Cero						:= 0;				-- Asignacion de Entero Vacio
	SET	Cadena_Vacia					:= '';				-- Asignacion de Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Asignacion de Fecha Vacia
	SET SalidaSI						:= 'S';				-- Asignacion de Salida SI
	SET Cons_SI							:= 'S';				-- Salida Si
	SET Cons_NO							:= 'N';				-- Salida Si
	SET Est_RelacionActiva				:= 'A';				-- Estatus de la relacion entre el credito Activo y pasivo (A= Activa)
	SET Est_RelacionVencida				:= 'V';				-- Estatus de la relacion entre el credito Activo y pasivo (V= Vencida)

	-- Declaracion de Valores Default
	SET Par_CreditoID					:= IFNULL(Par_CreditoID ,Entero_Cero);
	SET Par_CreditoFondeoID				:= IFNULL(Par_CreditoFondeoID ,Entero_Cero);

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat("El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que esto le ocasiona. Ref: SP-RELCREDPASIVOPRO");
			SET Var_Control = 'sqlException';
		END;

		IF(Par_CreditoID = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'Especifique el Numero de Credito a Fondear.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT CreditoID
		INTO Var_CreditoID
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

		IF(IFNULL(Var_CreditoID, Entero_Cero ) = Entero_Cero) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El Numero de Credito a Fondear No Existe.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CreditoFondeoID = Entero_Cero) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'Especifique el Numero de Credito de Pasivo Para el Credito.';
			SET Var_Control := 'creditoFondeoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT CreditoFondeoID
		INTO Var_CreditoFondeoID
		FROM CREDITOFONDEO
		WHERE CreditoFondeoID = Par_CreditoFondeoID;

		IF(IFNULL(Var_CreditoFondeoID, Entero_Cero ) = Entero_Cero) THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'El Numero de Credito de Pasivo a Fondear No Existe.';
			SET Var_Control := 'creditoFondeoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT COUNT(RelCreditoPasivoID)
		INTO Var_CounRelCredPasID
		FROM RELCREDPASIVO
		WHERE CreditoID = Par_CreditoID;

		-- Realizamos de baja si el credito ya tiene Asiganda un credito Pasivo
		IF (Var_CounRelCredPasID > Entero_Cero) THEN
			UPDATE RELCREDPASIVO SET
				EstatusRelacion = Est_RelacionVencida
			WHERE CreditoID = Par_CreditoID;
		END IF;

		-- Damos de Alta el nuevo registro del credito Asociada a una cuenta de Pasivo
		SELECT MAX(IFNULL(RelCreditoPasivoID,Entero_Cero)) + 1
		INTO Var_RelCreditoPasivoID
		FROM RELCREDPASIVO;

		INSERT INTO RELCREDPASIVO (
			Var_RelCreditoPasivoID,		Par_CreditoID,			Par_CreditoFondeoID,	Est_RelacionActiva,		Aud_EmpresaID,
			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion)
		VALUES(
			RelCreditoPasivoID,			CreditoID,				CreditoFondeoID,		EstatusRelacion,		Aud_EmpresaID,
			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		-- El registro se inserto correctamente
		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= 'Proceso Realizada Correctamente.';
		SET Var_Consecutivo	:= Var_RelCreditoPasivoID;
		SET Var_Control		:= 'registroCompleto';
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida =SalidaSI) THEN
		SELECT 	Par_NumErr				AS 	NumErr,
				Par_ErrMen				AS	ErrMen,
				Var_Control				AS	Control,
				Var_Consecutivo			AS	Consecutivo;
	END IF;
END TerminaStore$$