-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESAJUSTEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDESAJUSTEPRO`;DELIMITER $$

CREATE PROCEDURE `CEDESAJUSTEPRO`(
# ==============================================================
# ---------SP PARA REALIZAR EL AJUSTE DE TASAS DE CEDES---------
# ==============================================================
    Par_CedeID          INT(11),        -- ID de la Cede
    Par_TipoAjuste      INT(1),         -- Tipo de Ajuste: Nueva Tasa (1) o Reversa (2)

    Par_Salida          CHAR(1),        -- Salida en Pantalla
    INOUT   Par_NumErr  INT(11),        -- Salida en Pantalla Numero  de Error o Exito
    INOUT   Par_ErrMen  VARCHAR(400),   -- Salida en Pantalla Numero  de Error o Exito

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
	DECLARE Var_CedeID          INT(11);
	DECLARE Var_CedeMadre       INT(11);
	DECLARE Var_TasaMejorada    DECIMAL(14,4);
	DECLARE Var_TasaFV          CHAR(1);
	DECLARE Var_FechaSistema    DATE;
	DECLARE Var_DiasInversion   INT(11);
	DECLARE Var_TasaAnt         DECIMAL(14,4);
	DECLARE Var_Control         VARCHAR(200);

	-- CURSOR PARA EL RECALCULO DE INTERES
	DECLARE CURSORAMORTICEDE CURSOR FOR
		SELECT 	Ced.CedeID
			FROM 	TMPMEJORATASA Tmp,
					CEDES Ced,
					TIPOSCEDES Cat
			WHERE 	Tmp.CedeID 			= Ced.CedeID
			AND 	Ced.TipoCedeID 		= Cat.TipoCedeID
			AND 	Cat.TasaFV    		= ConsTasaFija
			AND 	Ced.TasaFija 		< Var_TasaMejorada
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
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-CEDESAJUSTEPRO');
				SET Var_Control='SQLEXCEPTION';
			END;

		SELECT  	FechaSistema,       DiasInversion
			INTO    Var_FechaSistema,   Var_DiasInversion
			FROM 	PARAMETROSSIS;

		IF(IFNULL(Par_CedeID,EnteroCero) = EnteroCero) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'En Numero de Cede esta Vacio.';
			SET Var_Control := 'CedeID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoAjuste = NuevaTasa) THEN

			-- Obtenemos el Valor de la Tasa del Cede Nuevo Anclado
			SELECT 		Ced.TasaFija INTO Var_TasaMejorada
				FROM 	CEDES Ced
				WHERE 	Ced.CedeID	= Par_CedeID;

			-- Obtenemos el ID de la Cede Madre.
			SELECT  	CedeOriID INTO  Var_CedeMadre
				FROM 	CEDESANCLAJE
				WHERE 	CedeAncID	= Par_CedeID;

			DELETE FROM TMPMEJORATASA
				WHERE NumTransaccion = Aud_NumTransaccion;

			-- Cede Madre
			INSERT INTO TMPMEJORATASA VALUES(Aud_NumTransaccion, Var_CedeMadre );

			-- Cedes Hijas Excluyendo la Que se esta Anclando (La Propia)
			INSERT INTO TMPMEJORATASA
				SELECT Aud_NumTransaccion, Anc.CedeAncID
					FROM CEDESANCLAJE Anc
					INNER JOIN CEDES Ced ON Anc.CedeAncID = Ced.CedeID
										AND Ced.Estatus = Est_Vigente
					WHERE Anc.CedeOriID = Var_CedeMadre
					  AND Anc.CedeAncID != Par_CedeID;

		-- Se Respalda la Cede Madre por una posible Reversa.
			INSERT INTO REVERSACEDESAJUSTE
				SELECT  	Par_CedeID,         cede.CedeID,        	cede.TasaFija,          cede.TasaNeta,      cede.TasaBase,
							cede.SobreTasa,     cede.PisoTasa,          cede.TechoTasa,    		cede.CalculoInteres,cede.ValorGat,
							cede.ValorGatReal,  cede.InteresGenerado,   cede.InteresRecibir,    Par_EmpresaID,      Aud_Usuario,
							Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,     	Aud_Sucursal,       Aud_NumTransaccion
					FROM 	CEDES cede
					WHERE 	cede.CedeID	= Var_CedeMadre;

			-- Considerar las Amortizaciones para la Reversa, CEDES Madre
			INSERT INTO `REVCEDEAMORTIANCLAJE`
				SELECT  	Aud_FechaActual, Par_CedeID,    cede.CedeID, Amo.AmortizacionID, Amo.Interes,
							Amo.Total
					FROM 	CEDES cede,
							AMORTIZACEDES Amo
					WHERE 	cede.CedeID = Var_CedeMadre
					  AND 	Amo.CedeID 	= cede.CedeID
					  AND 	Amo.Estatus = Est_Vigente;

		-- Respaldamos las Cedes Hijas por una Posible Reversa.
			INSERT INTO REVERSACEDESAJUSTE
				SELECT  	Par_CedeID, 		cede.CedeID,        	cede.TasaFija,          cede.TasaNeta,      cede.TasaBase,
							cede.SobreTasa,     cede.PisoTasa,          cede.TechoTasa,     	cede.CalculoInteres,cede.ValorGat,
							cede.ValorGatReal,  cede.InteresGenerado,   cede.InteresRecibir,    Par_EmpresaID,      Aud_Usuario,
							Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,     	Aud_Sucursal,       Aud_NumTransaccion
					FROM 	CEDESANCLAJE anc
							INNER JOIN CEDES cede ON anc.CedeAncID = cede.CedeID AND cede.Estatus = 'N'
					WHERE	anc.CedeOriID = Var_CedeMadre AND anc.CedeAncID != Par_CedeID;

			-- Considerar las Amortizaciones para la Reversa, CEDES Hijas
			INSERT INTO `REVCEDEAMORTIANCLAJE`
				SELECT  	Aud_FechaActual, Par_CedeID,    cede.CedeID, Amo.AmortizacionID, Amo.Interes,
							Amo.Total
					FROM 	CEDESANCLAJE anc,
							CEDES cede,
							AMORTIZACEDES Amo
					WHERE 	anc.CedeOriID 	= Var_CedeMadre
					  AND 	anc.CedeAncID 	= cede.CedeID
					  AND 	anc.CedeAncID 	!= Par_CedeID
					  AND 	cede.Estatus 	= Est_Vigente
					  AND 	Amo.CedeID 		= cede.CedeID
					  AND 	Amo.Estatus 	= Est_Vigente;

			OPEN CURSORAMORTICEDE;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					CICLO:LOOP

					FETCH CURSORAMORTICEDE INTO	Var_CedeID;

						-- Actualizamos el Valor de la Tasa
						UPDATE CEDES Ced SET
									Ced.TasaFija 	= Var_TasaMejorada,
									Ced.TasaNeta 	= Var_TasaMejorada - TasaISR
							WHERE 	CedeID 			= Var_CedeID;


						-- Mandamos llamar al Store que Recalcula el Interes de las Amortizaciones
						CALL `RECALINTERESCEDESPRO`(
							Var_CedeID,         SalidaNo,           Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
							Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
							Aud_NumTransaccion  );

						IF(Par_NumErr != EnteroCero) THEN
							LEAVE CICLO;
						END IF;
					END LOOP CICLO;
				END;
			CLOSE CURSORAMORTICEDE;
			IF(Par_NumErr = 0) THEN
				SET Par_ErrMen  :=  'Cede Ajustado Exitosamente.';
			END IF;
		END IF;


		IF(Par_TipoAjuste = Reversa) THEN

		-- Obtenemos el ID de la Cede Madre.
			SELECT  CedeOriID	INTO    Var_CedeMadre
				FROM 	CEDESANCLAJE
				WHERE 	CedeAncID	= Par_CedeID;

			SELECT  cat.TasaFV	INTO    Var_TasaFV
				FROM 	CEDES cede
						INNER JOIN TIPOSCEDES cat ON cede.TipoCedeID = cat.TipoCedeID
				WHERE 	cede.CedeID = Var_CedeMadre;


			IF(IFNULL(Var_CedeMadre,EnteroCero) = EnteroCero) THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  := 'El Cede Madre no Existe.';
				SET Var_Control := 'CedeID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Var_TasaFV,CadenaVacia) = CadenaVacia) THEN
				SET Par_NumErr  := 2;
				SET Par_ErrMen  := 'El Tipo de Tasa Esta Vacio,.';
				SET Var_Control := 'TasaID';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_TasaFV = ConsTasaFija) THEN
				UPDATE CEDES cede
					INNER JOIN  REVERSACEDESAJUSTE rever ON cede.CedeID = rever.CedeMejorada AND rever.CedeMejora = Par_CedeID
					SET cede.TasaFija           =   rever.Tasa,
						cede.TasaNeta           =   rever.TasaNeta,
						cede.ValorGat           =   rever.ValorGat,
						cede.ValorGatReal       =   rever.ValorGatReal,
						cede.InteresGenerado    =   rever.InteresGenerado,
						cede.InteresRecibir     =   rever.InteresRecibir,
						cede.UsuarioID          =   Aud_Usuario,
						cede.EmpresaID          =   Par_EmpresaID,
						cede.FechaActual        =   Aud_FechaActual,
						cede.DireccionIP        =   Aud_DireccionIP,
						cede.ProgramaID         =   Aud_ProgramaID,
						cede.Sucursal           =   Aud_Sucursal,
						cede.NumTransaccion     =   Aud_NumTransaccion;

				UPDATE AMORTIZACEDES Amo
					INNER JOIN  REVCEDEAMORTIANCLAJE rever ON Amo.CedeID = rever.CedeMejorada
														  AND Amo.AmortizacionID = rever.AmortizacionID
														  AND rever.CedeMejora = Par_CedeID

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

				UPDATE CEDES cede
					INNER JOIN  REVERSACEDESAJUSTE rever ON cede.CedeID = rever.CedeMejorada AND rever.CedeMejora = Par_CedeID
					SET cede.TasaFija           =   rever.Tasa,
						cede.TasaNeta           =   rever.TasaNeta,
						cede.TasaBase           =   rever.TasaBase,
						cede.SobreTasa          =   rever.SobreTasa,
						cede.PisoTasa           =   rever.PisoTasa,
						cede.TechoTasa          =   rever.TechoTasa,
						cede.CalculoInteres     =   rever.CalculoInteres,
						cede.ValorGat           =   rever.ValorGat,
						cede.ValorGatReal       =   rever.ValorGatReal,
						cede.InteresGenerado    =   rever.InteresGenerado,
						cede.InteresRecibir     =   rever.InteresRecibir,
						cede.UsuarioID          =   Aud_Usuario,
						cede.EmpresaID          =   Par_EmpresaID,
						cede.FechaActual        =   Aud_FechaActual,
						cede.DireccionIP        =   Aud_DireccionIP,
						cede.ProgramaID         =   Aud_ProgramaID,
						cede.Sucursal           =   Aud_Sucursal,
						cede.NumTransaccion     =   Aud_NumTransaccion;

			END IF;

			SET Par_NumErr  :=  0;
			SET Par_ErrMen  :=  'Cede Ajustado Exitosamente.';
			SET Var_Control :=  'CedeID';

		END IF;

        DELETE FROM TMPMEJORATASA	WHERE NumTransaccion = Aud_NumTransaccion;

	END ManejoErrores;

	IF (Par_Salida = SalidaSi) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				EnteroCero  AS consecutivo;
	END IF;

END TerminaStored$$