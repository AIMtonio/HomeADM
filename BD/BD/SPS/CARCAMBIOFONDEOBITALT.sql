-- SP CARCAMBIOFONDEOBITALT

DELIMITER ;

DROP PROCEDURE IF EXISTS CARCAMBIOFONDEOBITALT;

DELIMITER $$


CREATE PROCEDURE CARCAMBIOFONDEOBITALT(
	-- Stored Procedure para dar de alta la informacion de cambio de fondeo
	Par_FechaCambio						DATE,			-- Fecha en la que se realizo el cambio de Fondeo
	Par_CreditoID						BIGINT(12),		-- ID del Credito a cambiar de fondeador (Une con tabla de CREDITOS)
	Par_InstitutFondAntID				INT(11),		-- ID de la Institucion de Fondeo antes del cambio de Fondeo (une con tabla INSTITUTFONDEO)
	Par_LineaFondeoAntID				INT(11),		-- ID de la linea de Fondea de Pasivo antes del cambio de Fondeo
	Par_CreditoFondeoAntID				BIGINT(20),		-- ID del Credito de Pasivo antes del cambio de Fondeo

	Par_InstitutFondActID				INT(11),		-- ID de la Institucion de Fondeo Actual del Fondeo
	Par_LineaFondeoActID				INT(11),		-- ID de la linea de Fondea de Pasivo Actual del Fondeo
	Par_CreditoFondeoActID				BIGINT(20),		-- ID del Credito de Pasivo Actual del Fondeo

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

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);	-- Variable de Control SQL
	DECLARE	Var_Consecutivo				BIGINT(20);		-- Variable Consecutivo
	DECLARE Var_FechaSistema			DATE;			-- Variable de Fecha de sistema
	DECLARE Var_CreditoID				BIGINT(12);		-- Variable del numero del crédito
	DECLARE Var_InstitutFondID			INT(11);		-- Variable del Institucion de Fondeo
	DECLARE Var_LineaFondeoID			INT(11);		-- Variable del Linea de fondeo
	DECLARE Var_CreditoFondeoID			INT(11);		-- Variable del Credito pasivo FOndeo
	DECLARE Var_CarCambioFondeoID		BIGINT(20);		-- Variable de la tabla de cambio de fondeo

	-- Asignacion de Constantes
	SET Entero_Cero						= 0;				-- Asignacion de Entero Vacio
	SET	Cadena_Vacia					= '';				-- Asignacion de Cadena Vacia
	SET Fecha_Vacia						= '1900-01-01';		-- Asignacion de Fecha Vacia
	SET SalidaSI						= 'S';				-- Asignacion de Salida SI
	SET Cons_SI							= 'S';				-- Salida Si
	SET Cons_NO							= 'N';				-- Salida Si

	-- Declaracion de Valores Default
	SET Par_FechaCambio				:= IFNULL(Par_FechaCambio ,Fecha_Vacia);
	SET Par_CreditoID				:= IFNULL(Par_CreditoID ,Entero_Cero);
	SET Par_InstitutFondAntID		:= IFNULL(Par_InstitutFondAntID ,Entero_Cero);
	SET Par_LineaFondeoAntID		:= IFNULL(Par_LineaFondeoAntID ,Entero_Cero);
	SET Par_CreditoFondeoAntID		:= IFNULL(Par_CreditoFondeoAntID ,Entero_Cero);
	SET Par_InstitutFondActID		:= IFNULL(Par_InstitutFondActID ,Entero_Cero);
	SET Par_LineaFondeoActID		:= IFNULL(Par_LineaFondeoActID ,Entero_Cero);
	SET Par_CreditoFondeoActID		:= IFNULL(Par_CreditoFondeoActID ,Entero_Cero);


ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = concat("El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que esto le ocasiona. Ref: SP-CARCAMBIOFONDEOBITALT");
		SET Var_Control = 'sqlException';
	END;

	SELECT FechaSistema
		INTO Var_FechaSistema
		FROM PARAMETROSSIS;

	IF(Par_FechaCambio = Fecha_Vacia) THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'Especifique la Fecha de Cambio de Fondeo.';
		SET Var_Control := 'fechaCambio';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_FechaCambio > Var_FechaSistema) THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'Especifique la Fecha de Cambio de Fondeo no Mayor a la Fecha del Sistema.';
		SET Var_Control := 'fechaCambio';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_CreditoID = Entero_Cero) THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'Especifique el Numero de Credito a Fondear.';
		SET Var_Control := 'creditoID';
		LEAVE ManejoErrores;
	END IF;

	SELECT CreditoID
		INTO Var_CreditoID
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

	IF(IFNULL(Var_CreditoID, Entero_Cero ) = Entero_Cero) THEN
		SET Par_NumErr := 4;
		SET Par_ErrMen := 'El Numero de Credito a Fondear No Existe.';
		SET Var_Control := 'creditoID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_InstitutFondAntID < Entero_Cero) THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := 'Especifique el Numero de Institucion de Fondeo Anterior del Credito Mayor o Igual a Cero.';
		SET Var_Control := 'institutFondAntID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_LineaFondeoAntID < Entero_Cero) THEN
		SET Par_NumErr := 6;
		SET Par_ErrMen := 'Especifique el Numero de Linea de Fondeo Anterior del Credito Mayor o Igual a Cero.';
		SET Var_Control := 'lineaFondeoAntID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_CreditoFondeoAntID < Entero_Cero) THEN
		SET Par_NumErr := 7;
		SET Par_ErrMen := 'Especifique el Numero de Credito de Pasivo Anterior del Credito Mayor o Igual a Cero.';
		SET Var_Control := 'creditoFondeoAntID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_InstitutFondActID = Entero_Cero) THEN
		SET Par_NumErr := 8;
		SET Par_ErrMen := 'Especifique el Numero de Institucion de Fondeo Para el Credito.';
		SET Var_Control := 'institutFondActID';
		LEAVE ManejoErrores;
	END IF;

	SELECT InstitutFondID
		INTO Var_InstitutFondID
		FROM INSTITUTFONDEO
		WHERE InstitutFondID = Par_InstitutFondActID;

	IF(IFNULL(Var_InstitutFondID, Entero_Cero ) = Entero_Cero) THEN
		SET Par_NumErr := 9;
		SET Par_ErrMen := 'El Numero de Institucion de Fondeo Para el Credito. Valido';
		SET Var_Control := 'institutFondActID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_LineaFondeoActID = Entero_Cero) THEN
		SET Par_NumErr := 10;
		SET Par_ErrMen := 'Especifique el Numero de Linea de Fondeo Para el Credito.';
		SET Var_Control := 'lineaFondeoActID';
		LEAVE ManejoErrores;
	END IF;

	SELECT LineaFondeoID
		INTO Var_LineaFondeoID
		FROM LINEAFONDEADOR
		WHERE LineaFondeoID = Par_LineaFondeoActID;

	IF(IFNULL(Var_LineaFondeoID, Entero_Cero ) = Entero_Cero) THEN
		SET Par_NumErr := 11;
		SET Par_ErrMen := 'El Numero de Linea de Fondeo Para el Credito No Existe .';
		SET Var_Control := 'lineaFondeoActID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_CreditoFondeoActID = Entero_Cero) THEN
		SET Par_NumErr := 12;
		SET Par_ErrMen := 'Especifique el Numero de Credito de Pasivo Para el Credito.';
		SET Var_Control := 'creditoFondeoActID';
		LEAVE ManejoErrores;
	END IF;

	SELECT CreditoFondeoID
		INTO Var_CreditoFondeoID
		FROM CREDITOFONDEO
		WHERE CreditoFondeoID = Par_CreditoFondeoActID;

	IF(IFNULL(Var_CreditoFondeoID, Entero_Cero ) = Entero_Cero) THEN
		SET Par_NumErr := 13;
		SET Par_ErrMen := 'El Numero de Credito de Pasivo Para el Credito No Existe.';
		SET Var_Control := 'creditoFondeoActID';
		LEAVE ManejoErrores;
	END IF;

	SELECT MAX(IFNULL(CarCambioFondeoID,Entero_Cero)) + 1
		INTO Var_CarCambioFondeoID
			FROM CARCAMBIOFONDEOBIT;

	INSERT INTO CARCAMBIOFONDEOBIT (Var_CarCambioFondeoID,		Par_FechaCambio,		Par_CreditoID,			Par_InstitutFondAntID,		Par_LineaFondeoAntID,
									Par_CreditoFondeoAntID,		Par_InstitutFondActID,	Par_LineaFondeoActID,	Par_CreditoFondeoActID,		Aud_EmpresaID,
									Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,
									Aud_NumTransaccion)

							VALUES(	CarCambioFondeoID,			FechaCambio,			CreditoID,				InstitutFondAntID,			LineaFondeoAntID,
									CreditoFondeoAntID,			InstitutFondActID,		LineaFondeoActID,		CreditoFondeoActID,			Aud_EmpresaID,
									Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,
									Aud_NumTransaccion);

		-- El registro se inserto correctamente
		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Proceso Realizada Correctamente.';
		SET Var_Consecutivo	:= Var_CarCambioFondeoID;
		SET Var_Control	:= 'registroCompleto';
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida =SalidaSI) THEN
		SELECT 	Par_NumErr				AS 	NumErr,
				Par_ErrMen				AS	ErrMen,
				Var_Control				AS	Control,
				Var_Consecutivo			AS	Consecutivo;
	END IF;
END TerminaStore$$
