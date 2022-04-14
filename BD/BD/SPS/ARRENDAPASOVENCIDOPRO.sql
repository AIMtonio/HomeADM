-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDAPASOVENCIDOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRENDAPASOVENCIDOPRO`;DELIMITER $$

CREATE PROCEDURE `ARRENDAPASOVENCIDOPRO`(
# ===============================================================================================
# -- STORED PROCEDURE PARA EL TRASPASO A CARTERA VENCIDA DE UN ARRENDAMIENTO
# ===============================================================================================
	Par_Fecha			DATE,			-- Fecha del cierre

	Par_Salida			CHAR(1),		-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr	INT(11),		-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen	VARCHAR(400),	-- Parametro que corresponde a un mensaje de exito o error

	Par_EmpresaID		INT(11),		-- Parametros de Auditoria
	Aud_Usuario			INT(11),		-- Parametros de Auditoria
	Aud_FechaActual		DATETIME,		-- Parametros de Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Parametros de Auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Parametros de Auditoria
	Aud_Sucursal		INT(11),		-- Parametros de Auditoria
	Aud_NumTransaccion	BIGINT(20)		-- Parametros de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(50);	-- Variable de Control
	DECLARE Var_ArrendaID			BIGINT(12);		-- Variable para el Cursor
	DECLARE Var_ArrendaEst			CHAR(1);		-- Variable para el Cursor
	DECLARE Var_AmortiVen			INT(11);		-- Variable para el Cursor
	DECLARE Var_SumCapVig			DECIMAL(14,4);	-- Variable para el Cursor
	DECLARE Var_SumCapAtra			DECIMAL(14,4);	-- Variable para el Cursor
	DECLARE Var_SumCapVen			DECIMAL(14,4);	-- Variable para el Cursor
	DECLARE Var_SumIntVig			DECIMAL(14,4);	-- Variable para el Cursor
	DECLARE Var_SumIntAtra			DECIMAL(14,4);	-- Variable para el Cursor
	DECLARE Var_SumIntVen			DECIMAL(14,4);	-- Variable para el Cursor
	DECLARE Var_SumSeguro			DECIMAL(14,4);	-- Variable para el Cursor
	DECLARE Var_SumSegVida			DECIMAL(14,4);	-- Variable para el Cursor
	DECLARE Var_SumMora				DECIMAL(14,4);	-- Variable para el Cursor
	DECLARE Var_SumComFalPag		DECIMAL(14,4);	-- Variable para el Cursor
	DECLARE Var_SumOtrasComis		DECIMAL(14,4);	-- Variable para el Cursor

	-- Declaracion de Constantes.
	DECLARE Salida_Si				CHAR(1);		-- Indica que si se devuelve un mensaje de salida
	DECLARE Est_Vigente				CHAR(1);		-- Estatus Vigente
	DECLARE Est_Vencido				CHAR(1);		-- Estatus Vencido
	DECLARE Cadena_Vacia			CHAR(1);		-- Cadena Vacia
	DECLARE Fecha_Vacia				DATE;			-- Fecha Vacia
	DECLARE Entero_Cero				INT(11);		-- Entero Cero

	-- Cursor para los arrendamientos vigentes o vencidos
	DECLARE CURSORARRENDAVEN CURSOR FOR
		SELECT  ArrendaID,	Estatus
			FROM ARRENDAMIENTOS
			WHERE	Estatus = Est_Vigente
			   OR	Estatus = Est_Vencido;

	-- Asignacion de Constantes
	SET	Salida_Si			:= 'S';					-- El SP si genera una salida
	SET Est_Vigente			:= 'V';					-- Estatus Vigente
	SET Est_Vencido			:= 'B';					-- Estatus Vencido
	SET Cadena_Vacia		:= '';					-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';		-- Fecha Vacia
	SET Entero_Cero			:= 0;					-- Entero Cero

	-- Valores por default
	SET Par_Fecha			:= IFNULL(Par_Fecha, Fecha_Vacia);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: ARRENDAPASOVENCIDOPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		IF (Par_Fecha = Fecha_Vacia) THEN
			SET	Par_NumErr 	:= 001;
			SET	Par_ErrMen	:= 'La fecha esta vacia';
			SET Var_Control := 'Par_Fecha';
			LEAVE ManejoErrores;
		END IF;

		OPEN CURSORARRENDAVEN;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP
					FETCH CURSORARRENDAVEN INTO
						Var_ArrendaID,	Var_ArrendaEst;

					-- Se obtienen las sumas de los saldos de cada amortizacion para el arrendamiento actual
					SELECT		SUM(SaldoCapVigent),	SUM(SaldoCapAtrasad),	SUM(SaldoCapVencido),	SUM(SaldoInteresVigente),	SUM(SaldoInteresAtras),
								SUM(SaldoInteresVen),	SUM(SaldoSeguro),		SUM(SaldoSeguroVida),	SUM(SaldoMoratorios),		SUM(SaldComFaltPago),
								SUM(SaldoOtrasComis)
					  INTO		Var_SumCapVig,			Var_SumCapAtra,			Var_SumCapVen,			Var_SumIntVig,				Var_SumIntAtra,
								Var_SumIntVen,			Var_SumSeguro,			Var_SumSegVida,			Var_SumMora,				Var_SumComFalPag,
								Var_SumOtrasComis
						FROM ARRENDAAMORTI
						WHERE	ArrendaID = Var_ArrendaID;

					SET Var_SumCapVig		:= IFNULL(Var_SumCapVig, Entero_Cero);
					SET Var_SumCapAtra		:= IFNULL(Var_SumCapAtra, Entero_Cero);
					SET Var_SumCapVen		:= IFNULL(Var_SumCapVen, Entero_Cero);
					SET Var_SumIntVig		:= IFNULL(Var_SumIntVig, Entero_Cero);
					SET Var_SumIntAtra		:= IFNULL(Var_SumIntAtra, Entero_Cero);
					SET Var_SumIntVen		:= IFNULL(Var_SumIntVen, Entero_Cero);
					SET Var_SumSeguro		:= IFNULL(Var_SumSeguro, Entero_Cero);
					SET Var_SumSegVida		:= IFNULL(Var_SumSegVida, Entero_Cero);
					SET Var_SumMora			:= IFNULL(Var_SumMora, Entero_Cero);
					SET Var_SumComFalPag	:= IFNULL(Var_SumComFalPag, Entero_Cero);
					SET Var_SumOtrasComis	:= IFNULL(Var_SumOtrasComis, Entero_Cero);

					/* Se actualizan los valores de los saldos en el arrendamiento con los valores
					de las sumatorias obtenidas previamente */
					UPDATE ARRENDAMIENTOS SET
						SaldoCapVigente		= Var_SumCapVig,
						SaldoCapAtrasad		= Var_SumCapAtra,
						SaldoCapVencido		= Var_SumCapVen,
						SaldoInteresVigent	= Var_SumIntVig,
						SaldoInteresAtras	= Var_SumIntAtra,
						SaldoInteresVen		= Var_SumIntVen,
						SaldoSeguro			= Var_SumSeguro,
						SaldoSeguroVida		= Var_SumSegVida,
						SaldoMoratorios		= Var_SumMora,
						SaldComFaltPago		= Var_SumComFalPag,
						SaldoOtrasComis		= Var_SumOtrasComis
						WHERE	ArrendaID	= Var_ArrendaID;

					-- Se hace un conteo de las amortizaciones con estatus vencido para el arrendamiento actual
					SELECT	COUNT(ArrendaID)
					  INTO	Var_AmortiVen
						FROM ARRENDAAMORTI
						WHERE	ArrendaID = Var_ArrendaID
						  AND	Estatus   = Est_Vencido;

					/* Si el estatus del arrendamiento es vigente y se encuentra
					al menos una amortizacion vencida para ese arrendamiento
					se hace el traspaso a estatus vencido del arrendamiento */
					IF ((Var_AmortiVen > Entero_Cero) AND (Var_ArrendaEst = Est_Vigente)) THEN
						UPDATE ARRENDAMIENTOS SET
							Estatus				= Est_Vencido,
							FechaTraspasaVen	= Par_Fecha
							WHERE	ArrendaID	= Var_ArrendaID;
					END IF;
				END LOOP;
			END;
		CLOSE CURSORARRENDAVEN;

		-- La operacion se realizo exitosamente.
		SET	Par_NumErr 	:= 000;
		SET	Par_ErrMen	:= 'Operacion realizada exitosamente';
		SET Var_Control := 'Par_Fecha';
	END ManejoErrores; -- Fin del bloque manejo de errores

	IF (Par_Salida = Salida_Si) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control;
	END IF;
END TerminaStore$$