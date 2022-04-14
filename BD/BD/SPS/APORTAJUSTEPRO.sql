-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTAJUSTEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTAJUSTEPRO`;DELIMITER $$

CREATE PROCEDURE `APORTAJUSTEPRO`(
# ==============================================================
# ---------SP PARA REALIZAR EL AJUSTE DE TASAS DE APORTACIONES---------
# ==============================================================
    Par_AportacionID	INT(11),        -- ID de la aportacion
    Par_TipoAjuste      INT(1),         -- Tipo de Ajuste: Nueva Tasa (1) o Reversa (2)
    Par_Salida          CHAR(1),        -- Salida en Pantalla
    INOUT Par_NumErr	INT(11),        -- Salida en Pantalla Numero  de Error o Exito
    INOUT Par_ErrMen	VARCHAR(400),   -- Salida en Pantalla Numero  de Error o Exito

    Par_EmpresaID       INT(11),        -- Auditoria
    Aud_Usuario         INT(11),        -- Auditoria
    Aud_FechaActual     DATETIME,       -- Auditoria
    Aud_DireccionIP     VARCHAR(15),    -- Auditoria
    Aud_ProgramaID      VARCHAR(50),    -- Auditoria

    Aud_Sucursal        INT(11),        -- Auditoria
    Aud_NumTransaccion  BIGINT(20)      -- Auditoria
)
TerminaStored: BEGIN

	-- Declaracion de constantes
	DECLARE NuevaTasa           INT(1);
	DECLARE Reversa             INT(1);
	DECLARE EnteroCero          INT(1);
	DECLARE CadenaVacia         CHAR(1);
	DECLARE SalidaSi            CHAR(1);
	DECLARE SalidaNo            CHAR(1);
	DECLARE ConsTasaFija        CHAR(1);
	DECLARE TasaVariable        CHAR(1);
	DECLARE Est_Vigente         CHAR(1);

	-- Declaracion de variables
	DECLARE Var_AportacionID	INT(11);
	DECLARE Var_AportMadre		INT(11);
	DECLARE Var_TasaMejorada    DECIMAL(14,4);
	DECLARE Var_TasaFV          CHAR(1);
	DECLARE Var_FechaSistema    DATE;
	DECLARE Var_DiasInversion   INT(11);
	DECLARE Var_TasaAnt         DECIMAL(14,4);
	DECLARE Var_Control         VARCHAR(200);

	-- CURSOR PARA EL RECALCULO DE INTERES
	DECLARE CURSORAMORTAPORT CURSOR FOR
		SELECT 	Ap.AportacionID
			FROM 	TMPMEJORATASAAP Tmp,
					APORTACIONES Ap,
					TIPOSAPORTACIONES Cat
			WHERE 	Tmp.AportacionID 			= Ap.AportacionID
			AND 	Ap.TipoAportacionID 		= Cat.TipoAportacionID
			AND 	Cat.TasaFV    		= ConsTasaFija
			AND 	Ap.TasaFija 		< Var_TasaMejorada
			AND 	Tmp.NumTransaccion	= Aud_NumTransaccion;

	-- Asignacion de constantes
	SET NuevaTasa           := 1;              -- Tipo de Actualizcion Nueva Tasa
	SET Reversa             := 2;              -- Tipo de Actualizcion Reversa
	SET EnteroCero          := 0;              -- Entero en Cero
	SET CadenaVacia         := '';             -- Cadena Vacia
	SET SalidaSi            := 'S';            -- Salida SI
	SET SalidaNo            := 'N';            -- Salida NO
	SET ConsTasaFija        := 'F';            -- Tipo de Tasa: Fija
	SET TasaVariable        := 'V';            -- Tipo de Tasa: Variable
	SET Var_TasaAnt         := 0.00;           -- Tasa Anterior
	SET Est_Vigente         := 'N';            -- Estatus Vigente

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-APORTAJUSTEPRO');
				SET Var_Control:='SQLEXCEPTION';
			END;

		SELECT  	FechaSistema,       DiasInversion
			INTO    Var_FechaSistema,   Var_DiasInversion
			FROM 	PARAMETROSSIS;

		IF(IFNULL(Par_AportacionID,EnteroCero) = EnteroCero) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'En Numero de Aportacion esta Vacio.';
			SET Var_Control := 'AportacionID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoAjuste = NuevaTasa) THEN

			-- Obtenemos el Valor de la Tasa de la Aportacion Nueva Anclada
			SELECT 		Ap.TasaFija INTO Var_TasaMejorada
				FROM 	APORTACIONES Ap
				WHERE 	Ap.AportacionID	= Par_AportacionID;

			-- Obtenemos el ID de la Aportacion Madre.
			SELECT  	AportacionOriID INTO  Var_AportMadre
				FROM 	APORTANCLAJE
				WHERE 	AportacionAncID	= Par_AportacionID;

			DELETE FROM TMPMEJORATASAAP
				WHERE NumTransaccion = Aud_NumTransaccion;

			-- Aport Madre
			INSERT INTO TMPMEJORATASAAP VALUES(Aud_NumTransaccion, Var_AportMadre );

			-- Aportaciones Hijas Excluyendo la Que se esta Anclando (La Propia)
			INSERT INTO TMPMEJORATASAAP
				SELECT Aud_NumTransaccion, Anc.AportacionAncID
					FROM APORTANCLAJE Anc
					INNER JOIN APORTACIONES Ap ON Anc.AportacionAncID = Ap.AportacionID
										AND Ap.Estatus = Est_Vigente
					WHERE Anc.AportacionOriID = Var_AportMadre
					  AND Anc.AportacionAncID != Par_AportacionID;

		-- Se Respalda la Aport Madre por una posible Reversa.
			INSERT INTO REVERSAAJUSTEAPORT
				SELECT  	Par_AportacionID,	aport.AportacionID,		aport.TasaFija,			aport.TasaNeta,      aport.TasaBase,
							aport.SobreTasa,	aport.PisoTasa,			aport.TechoTasa,		aport.CalculoInteres,aport.ValorGat,
							aport.ValorGatReal,	aport.InteresGenerado,	aport.InteresRecibir,	Par_EmpresaID,      Aud_Usuario,
							Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,     	Aud_Sucursal,       Aud_NumTransaccion
					FROM 	APORTACIONES aport
					WHERE 	aport.AportacionID	= Var_AportMadre;

			-- Considerar las Amortizaciones para la Reversa, APORTACIONES Madre
			INSERT INTO `REVAPORTAMORTANCLAJE`
				SELECT  	Aud_FechaActual, Par_AportacionID,    aport.AportacionID, Amo.AmortizacionID, Amo.Interes,
							Amo.Total
					FROM 	APORTACIONES aport,
							AMORTIZAAPORT Amo
					WHERE 	aport.AportacionID = Var_AportMadre
					  AND 	Amo.AportacionID 	= aport.AportacionID
					  AND 	Amo.Estatus = Est_Vigente;

		-- Respaldamos las Aportaciones Hijas por una Posible Reversa.
			INSERT INTO REVERSAAJUSTEAPORT
				SELECT  	Par_AportacionID,	aport.AportacionID,		aport.TasaFija,			aport.TasaNeta,      aport.TasaBase,
							aport.SobreTasa,	aport.PisoTasa,			aport.TechoTasa,     	aport.CalculoInteres,aport.ValorGat,
							aport.ValorGatReal,	aport.InteresGenerado,	aport.InteresRecibir,	Par_EmpresaID,      Aud_Usuario,
							Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,     	Aud_Sucursal,       Aud_NumTransaccion
					FROM 	APORTANCLAJE anc
							INNER JOIN APORTACIONES aport ON anc.AportacionAncID = aport.AportacionID AND aport.Estatus = 'N'
					WHERE	anc.AportacionOriID = Var_AportMadre AND anc.AportacionAncID != Par_AportacionID;

			-- Considerar las Amortizaciones para la Reversa, APORTACIONES Hijas
			INSERT INTO `REVAPORTAMORTANCLAJE`
				SELECT  	Aud_FechaActual, Par_AportacionID,    aport.AportacionID, Amo.AmortizacionID, Amo.Interes,
							Amo.Total
					FROM 	APORTANCLAJE anc,
							APORTACIONES aport,
							AMORTIZAAPORT Amo
					WHERE 	anc.AportacionOriID 	= Var_AportMadre
					  AND 	anc.AportacionAncID 	= aport.AportacionID
					  AND 	anc.AportacionAncID 	!= Par_AportacionID
					  AND 	aport.Estatus 	= Est_Vigente
					  AND 	Amo.AportacionID 		= aport.AportacionID
					  AND 	Amo.Estatus 	= Est_Vigente;

			OPEN CURSORAMORTAPORT;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					CICLO:LOOP

					FETCH CURSORAMORTAPORT INTO	Var_AportacionID;

						-- Actualizamos el Valor de la Tasa
						UPDATE APORTACIONES Ap SET
									Ap.TasaFija 	= Var_TasaMejorada,
									Ap.TasaNeta 	= Var_TasaMejorada - TasaISR
							WHERE 	AportacionID 			= Var_AportacionID;


						-- Mandamos llamar al Store que Recalcula el Interes de las Amortizaciones
						CALL `RECALINTAPORTPRO`(
							Var_AportacionID,	SalidaNo,           Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
							Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
							Aud_NumTransaccion  );

						IF(Par_NumErr != EnteroCero) THEN
							LEAVE CICLO;
						END IF;
					END LOOP CICLO;
				END;
			CLOSE CURSORAMORTAPORT;
			IF(Par_NumErr = 0) THEN
				SET Par_ErrMen  :=  'Aportacion Ajustada Exitosamente.';
			END IF;
		END IF;


		IF(Par_TipoAjuste = Reversa) THEN

		-- Obtenemos el ID de la Aportacion Madre.
			SELECT  AportacionOriID	INTO    Var_AportMadre
				FROM 	APORTANCLAJE
				WHERE 	AportacionAncID	= Par_AportacionID;

			SELECT  cat.TasaFV	INTO    Var_TasaFV
				FROM 	APORTACIONES aport
						INNER JOIN TIPOSAPORTACIONES cat ON aport.TipoAportacionID = cat.TipoAportacionID
				WHERE 	aport.AportacionID = Var_AportMadre;


			IF(IFNULL(Var_AportMadre,EnteroCero) = EnteroCero) THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  := 'La Aportacion Madre no Existe.';
				SET Var_Control := 'AportacionID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Var_TasaFV,CadenaVacia) = CadenaVacia) THEN
				SET Par_NumErr  := 2;
				SET Par_ErrMen  := 'El Tipo de Tasa Esta Vacio,.';
				SET Var_Control := 'TasaID';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_TasaFV = ConsTasaFija) THEN
				UPDATE APORTACIONES aport
					INNER JOIN  REVERSAAJUSTEAPORT rever ON aport.AportacionID = rever.AportMejorada AND rever.AportMejora = Par_AportacionID
					SET aport.TasaFija           =   rever.Tasa,
						aport.TasaNeta           =   rever.TasaNeta,
						aport.ValorGat           =   rever.ValorGat,
						aport.ValorGatReal       =   rever.ValorGatReal,
						aport.InteresGenerado    =   rever.InteresGenerado,
						aport.InteresRecibir     =   rever.InteresRecibir,
						aport.UsuarioID          =   Aud_Usuario,
						aport.EmpresaID          =   Par_EmpresaID,
						aport.FechaActual        =   Aud_FechaActual,
						aport.DireccionIP        =   Aud_DireccionIP,
						aport.ProgramaID         =   Aud_ProgramaID,
						aport.Sucursal           =   Aud_Sucursal,
						aport.NumTransaccion     =   Aud_NumTransaccion;

				UPDATE AMORTIZAAPORT Amo
					INNER JOIN  REVAPORTAMORTANCLAJE rever ON Amo.AportacionID = rever.AportMejorada
														  AND Amo.AmortizacionID = rever.AmortizacionID
														  AND rever.AportMejora = Par_AportacionID

					SET Amo.Interes         =   rever.Interes,
						Amo.Total           =   rever.Total,

						Amo.Usuario         =   Aud_Usuario,
						Amo.EmpresaID       =   Par_EmpresaID,
						Amo.FechaActual     =   Aud_FechaActual,
						Amo.DireccionIP     =   Aud_DireccionIP,
						Amo.ProgramaID      =   Aud_ProgramaID,
						Amo.Sucursal        =   Aud_Sucursal,
						Amo.NumTransaccion  =   Aud_NumTransaccion;

			END IF;

			IF(Var_TasaFV = TasaVariable) THEN

				UPDATE APORTACIONES aport
					INNER JOIN  REVERSAAJUSTEAPORT rever ON aport.AportacionID = rever.AportMejorada AND rever.AportMejora = Par_AportacionID
					SET aport.TasaFija           =   rever.Tasa,
						aport.TasaNeta           =   rever.TasaNeta,
						aport.TasaBase           =   rever.TasaBase,
						aport.SobreTasa          =   rever.SobreTasa,
						aport.PisoTasa           =   rever.PisoTasa,
						aport.TechoTasa          =   rever.TechoTasa,
						aport.CalculoInteres     =   rever.CalculoInteres,
						aport.ValorGat           =   rever.ValorGat,
						aport.ValorGatReal       =   rever.ValorGatReal,
						aport.InteresGenerado    =   rever.InteresGenerado,
						aport.InteresRecibir     =   rever.InteresRecibir,
						aport.UsuarioID          =   Aud_Usuario,
						aport.EmpresaID          =   Par_EmpresaID,
						aport.FechaActual        =   Aud_FechaActual,
						aport.DireccionIP        =   Aud_DireccionIP,
						aport.ProgramaID         =   Aud_ProgramaID,
						aport.Sucursal           =   Aud_Sucursal,
						aport.NumTransaccion     =   Aud_NumTransaccion;

			END IF;

			SET Par_NumErr  :=  0;
			SET Par_ErrMen  :=  'Aportacion Ajustada Exitosamente.';
			SET Var_Control :=  'AportacionID';

		END IF;

        DELETE FROM TMPMEJORATASAAP	WHERE NumTransaccion = Aud_NumTransaccion;

	END ManejoErrores;

	IF (Par_Salida = SalidaSi) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				EnteroCero  AS consecutivo;
	END IF;

END TerminaStored$$