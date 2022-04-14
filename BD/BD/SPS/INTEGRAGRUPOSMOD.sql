-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INTEGRAGRUPOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `INTEGRAGRUPOSMOD`;
DELIMITER $$


CREATE PROCEDURE `INTEGRAGRUPOSMOD`(
    Par_Solicitud       INT(11),
    Par_ProspectoID     BIGINT(20),
    Par_ClienteID       INT(11),
    Par_ProduCredID     INT(11),
    Par_GrupoID         INT(10),

    Par_Cargo           INT(11),
    Par_PonderaCiclo    CHAR(1),
    Par_AntCteID        BIGINT,
    Par_AntProspeID     BIGINT,
	Par_TipoIntegr      INT(11),

    Par_Salida          CHAR(1),
	INOUT Par_NumErr    INT(11),
	INOUT Par_ErrMen    VARCHAR(400),
	/* Parametros de Auditoria */
	Par_EmpresaID       INT(11),
	Aud_Usuario         INT(11),

	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
	)

TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_IntSolCreID 		BIGINT;
DECLARE Var_IntMonSol			DECIMAL(14,2);
DECLARE Var_SucursalID			INT;
DECLARE Var_NumTraSim			BIGINT;
DECLARE Var_TasaFija			DECIMAL(12,4);
DECLARE Var_GruEstatus			CHAR(1);
DECLARE Var_CicloCliente    	INT;
DECLARE Var_CicloGrupo      	INT;
DECLARE Var_CicloPond       	INT;
DECLARE Var_DesCargo    		VARCHAR(45);
DECLARE Var_Cargo				INT;
DECLARE Var_SolicitudCreditoID	INT(11);
DECLARE Var_CalificaCredito		CHAR(1);
DECLARE Var_PlazoID				VARCHAR(20);
DECLARE Var_CalcInteres			INT(11);
DECLARE Var_InstitucionNominaID			INT(11);
DECLARE Var_EsNomina			CHAR(1);
DECLARE Var_NumTasasNivel		INT(11);
DECLARE Var_NivelID				INT(11);

-- Declaracion de constantes
DECLARE Cadena_Vacia    		CHAR(1);
DECLARE Fecha_Vacia     		DATE;
DECLARE Entero_Cero     		INT;
DECLARE Str_SI          		CHAR(1);
DECLARE Str_NO          		CHAR(1);
DECLARE Gru_Abierto     		CHAR(1);
DECLARE Gru_Cerrado     		CHAR(1);
DECLARE PonderaCiclo_SI 		CHAR(1);
DECLARE Estatus_Activo  		CHAR(1);
DECLARE SalidaNO        		CHAR(1);
DECLARE SalidaSI        		CHAR(1);

DECLARE Cargo_Presiden  		INT(1);
DECLARE Cargo_Tesorero  		INT(1);
DECLARE Cargo_Secretar 			INT(1);
DECLARE Cargo_Integra   		INT(1);
DECLARE CalifNoAsigna   		CHAR(1);
DECLARE CalifExcelente  		CHAR(1);
DECLARE CalifBuena      		CHAR(1);
DECLARE CalifRegular    		CHAR(1);
DECLARE TasaFijaID				INT(11);

DECLARE CURSORGRUPOTASA CURSOR FOR
    SELECT Sol.SolicitudCreditoID, Sol.MontoSolici, Sol.SucursalID, Sol.NumTransacSim,Cli.CalificaCredito,Sol.PlazoID,
    InstitucionNominaID
        FROM INTEGRAGRUPOSCRE Ing,
             SOLICITUDCREDITO Sol
				INNER JOIN CLIENTES Cli ON Sol.ClienteID=Cli.ClienteID
        WHERE Ing.GrupoID   = Par_GrupoID
          AND Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
          AND Ing.Estatus   = Estatus_Activo;

-- Asignacion de constantes
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Str_SI          := 'S';
SET Str_NO          := 'N';
SET Gru_Abierto     := 'A';             -- Estatus del Grupo: Cerrado
SET Gru_Cerrado     := 'C';             -- Estatus del Grupo: Abierto
SET PonderaCiclo_SI := 'S';
SET Estatus_Activo  := 'A';
SET SalidaSI        := 'S';
SET SalidaNO        := 'N';
SET Cargo_Presiden  := 1;  				--  corresponde con INTEGRAGRUPOSCRE Presidente del grupo
SET Cargo_Tesorero  := 2;       		--  corresponde con INTEGRAGRUPOSCRE Tesorero del grupo
SET Cargo_Secretar  := 3;       		--  corresponde con INTEGRAGRUPOSCRE Secretario del grupo
SET Cargo_Integra   := 4; 				--  corresponde con INTEGRAGRUPOSCRE Integrante del grupo
SET CalifNoAsigna   := 'N';				--  Calificacion: No Asignada
SET CalifExcelente  := 'A';				--  Calificacion: Excelente
SET CalifBuena      := 'B';				--  Calificacion: Buena
SET CalifRegular    := 'C';				--  Calificacion: Regular
SET TasaFijaID		:= 1;				--  ID de la formula para tasa fija (FORMTIPOCALINT)

-- Inicializacion
SET	Par_NumErr 		:= 1;
SET	Par_ErrMen 		:= Cadena_Vacia;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-INTEGRAGRUPOSMOD');
		END;

	-- Se obtiene la formula del calculo de intereses del producto de credito
	SELECT CalcInteres, ProductoNomina INTO Var_CalcInteres, Var_EsNomina
		FROM PRODUCTOSCREDITO
			WHERE ProducCreditoID=IFNULL(Par_ProduCredID, Entero_Cero);

	/*	Sp que se utiliza para validar que todos los valores en un grupo de solicitudes de
		credito sean iguales (producto de credito,  plazo, frecuencias y demas valores
		para generar el calendario de pagos) */
	CALL SOLCREGRUALTMODVAL(
		Par_Solicitud,			Par_ProspectoID,	Par_ClienteID,	Par_GrupoID,		Par_TipoIntegr,
		SalidaNO,				Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

	IF (Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	-- se valida que no existan dos integrantes con el mismo puesto en el grupo de credito
	IF (Par_TipoIntegr != Cargo_Integra) THEN
		SELECT Ing.Cargo,Ing.SolicitudCreditoID INTO Var_Cargo, Var_SolicitudCreditoID
				FROM INTEGRAGRUPOSCRE Ing
					WHERE 	Ing.Cargo = Par_TipoIntegr
					AND 	Ing.GrupoID=Par_GrupoID
					AND 	Ing.Estatus	=Estatus_Activo
					LIMIT 1;

		SET Var_Cargo :=IFNULL(Var_Cargo,Entero_Cero);
		IF (Var_Cargo > Entero_Cero AND Par_Solicitud != Var_SolicitudCreditoID)THEN
			IF (Par_TipoIntegr = Cargo_Presiden)THEN
				SET Var_DesCargo := 'Presidente';
			END IF;
			IF (Par_TipoIntegr = Cargo_Tesorero)THEN
				SET Var_DesCargo := 'Tesorero';
			END IF;
			IF (Par_TipoIntegr = Cargo_Secretar)THEN
				SET Var_DesCargo := 'Secretario';
			END IF;

			SET Par_NumErr :='01';
			SET Par_ErrMen := CONCAT("Solo puede existir un ",Var_DesCargo," en el Grupo");
			LEAVE ManejoErrores;
		END IF;

	END IF;

	SELECT CicloPonderado, EstatusCiclo  INTO Var_CicloPond, Var_GruEstatus
		FROM GRUPOSCREDITO
		WHERE GrupoID = Par_GrupoID;

	SET Var_GruEstatus  := IFNULL(Var_GruEstatus, Cadena_Vacia);

	CALL CRECALCULOCICLOPRO(
		Par_ClienteID,      Par_ProspectoID,    Par_ProduCredID,    Par_GrupoID,    Var_CicloCliente,
		Var_CicloGrupo,     SalidaNO,           Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,
		Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

	-- Revisamos si el Cliente o Prospecto Cambio
	IF (Par_AntCteID != Par_ClienteID OR Par_AntProspeID != Par_ProspectoID) THEN
		UPDATE INTEGRAGRUPOSCRE SET
			ClienteID   = Par_ClienteID,
			ProspectoID = Par_ProspectoID,
			Ciclo       = Var_CicloCliente,
			Cargo       = Par_TipoIntegr
			WHERE SolicitudCreditoID = Par_Solicitud;
	ELSE
		UPDATE INTEGRAGRUPOSCRE SET
			Ciclo       = Var_CicloCliente,
			Cargo       = Par_TipoIntegr
			WHERE SolicitudCreditoID = Par_Solicitud;
	END IF;


	IF(Par_PonderaCiclo = PonderaCiclo_SI) THEN
		SET Var_CicloPond   := IFNULL(Var_CicloPond, Entero_Cero);   /*Se asegura de no tener valor nulo*/

		/* Si es diferente se actualiza el ciclo en la tabla de grupos*/
		UPDATE GRUPOSCREDITO SET
			CicloPonderado = Var_CicloGrupo
			WHERE GrupoID = Par_GrupoID;

		/* Si el calculo de Interes es por Tasa Fija
		 * se actualiza la tasa de acuerdo al esquema de tasas */
		IF(IFNULL(Var_CalcInteres,Entero_Cero)=TasaFijaID)THEN
			/* Se hace un recalculo de la tasa y se actualiza en la solicitud de credito*/
			OPEN CURSORGRUPOTASA;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLOINTASA:LOOP

					FETCH CURSORGRUPOTASA  INTO
						Var_IntSolCreID,    Var_IntMonSol,  Var_SucursalID, Var_NumTraSim,Var_CalificaCredito,Var_PlazoID,
                        Var_InstitucionNominaID;

					CALL ESQUEMATASACALPRO(
						Var_SucursalID, 	Par_ProduCredID,    Var_CicloGrupo,		Var_IntMonSol,  	Var_CalificaCredito,
						Var_TasaFija, 		Var_PlazoID, 		Var_InstitucionNominaID,Entero_Cero,	Var_NivelID,
                        SalidaNO,			Par_NumErr,         Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,    
                        Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF(Var_TasaFija <= Entero_Cero) THEN
						SET Par_NumErr  := 999;
						SET Par_ErrMen  := CONCAT('No existe esquema de Tasa para la Solicitud: ',
													  CONVERT(Var_IntSolCreID, CHAR),
													' con Ciclo: ',CONVERT(Var_CicloGrupo,CHAR),
													'  y Calificacion: ',CASE WHEN Var_CalificaCredito = CalifExcelente THEN 'Excelente'
																			WHEN	Var_CalificaCredito = CalifNoAsigna THEN 'No Asignada'
																			WHEN Var_CalificaCredito = CalifBuena THEN 'Buena'
																			WHEN Var_CalificaCredito = CalifRegular THEN 'Regular' END );


						LEAVE CICLOINTASA;
					END IF;

					UPDATE SOLICITUDCREDITO SET
						TasaFija = Var_TasaFija,
						NivelID = IFNULL(Var_NivelID,Entero_Cero),
						NumTransacSim   = Entero_Cero
						WHERE SolicitudCreditoID = Var_IntSolCreID;

					DELETE FROM TMPPAGAMORSIM
						WHERE NumTransaccion    = Var_NumTraSim;

				END LOOP CICLOINTASA;
			END;
			CLOSE CURSORGRUPOTASA;

			IF (Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

	ELSE -- Else del if(Par_PonderaCiclo = PonderaCiclo_SI) then
		/* Si el calculo de Interes es por Tasa Fija
		 * se actualiza la tasa de acuerdo al esquema de tasas */
		IF(IFNULL(Var_CalcInteres,Entero_Cero)=TasaFijaID)THEN
			SELECT  Sol.SucursalID, Sol.MontoSolici,Sol.PlazoID INTO Var_SucursalID, Var_IntMonSol,Var_PlazoID
				FROM SOLICITUDCREDITO Sol,
					 PRODUCTOSCREDITO Pro
				WHERE Sol.SolicitudCreditoID = Par_Solicitud
				  AND Sol.ProductoCreditoID = Pro.ProducCreditoID;

			SELECT CalificaCredito INTO  Var_CalificaCredito
				FROM CLIENTES
					WHERE ClienteID = Par_ClienteID;

			-- VALIDACION PARA CONTAR SI LA SOLICITUD COINCIDE CON UN ESQUEMA DE NIVELES DE CREDITO
			SET Var_EsNomina := IFNULL(Var_EsNomina, 'N');
            IF(Var_EsNomina = 'N') THEN
				SET Var_NumTasasNivel := (SELECT COUNT(TasaFija)
											FROM ESQUEMATASAS Est
												INNER JOIN NIVELCREDITO NIV
													ON Est.NivelID = NIV.NivelID
											WHERE  	   Est.SucursalID 			 = Var_SucursalID
												AND	   Est.ProductoCreditoID 	 = Par_ProduCredID
												AND    Est.MinCredito			<= Var_CicloCliente
												AND    Est.MaxCredito			>= Var_CicloCliente
												AND    Est.MontoInferior		<= Var_IntMonSol
												AND    Est.MontoSuperior		>= Var_IntMonSol
												AND    Est.Calificacion			 = Var_CalificaCredito
												AND	   (Est.PlazoID				 IN (Var_PlazoID) OR Est.PlazoID='T')
											);
			ELSE
				SET Var_NumTasasNivel := (SELECT COUNT(TasaFija)
											FROM ESQUEMATASAS Est
												INNER JOIN NIVELCREDITO NIV
													ON Est.NivelID = NIV.NivelID
											WHERE  	   Est.SucursalID 			 = Var_SucursalID
												AND	   Est.ProductoCreditoID 	 = Par_ProduCredID
												AND    Est.MinCredito			<= Var_CicloCliente
												AND    Est.MaxCredito			>= Var_CicloCliente
												AND    Est.MontoInferior		<= Var_IntMonSol
												AND    Est.MontoSuperior		>= Var_IntMonSol
												AND    Est.Calificacion			 = Var_CalificaCredito
												AND	   (Est.PlazoID				 IN (Var_PlazoID) OR Est.PlazoID='T')
												AND		(Est.InstitNominaID IN(Var_InstitucionNominaID) OR Est.InstitNominaID = 0)
											);

			END IF;

            -- SI NO EXISTE UN ESQUEMA DE TASAS CON NIVELES  HACE EL PROCESO NORMAL
            IF(IFNULL(Var_NumTasasNivel,Entero_Cero) <= Entero_Cero )THEN

				CALL ESQUEMATASACALPRO(
					Var_SucursalID, 	Par_ProduCredID,    Var_CicloCliente,   Var_IntMonSol,  	Var_CalificaCredito,
					Var_TasaFija,		Var_PlazoID,  		Var_InstitucionNominaID,Entero_Cero,	Var_NivelID,
                    SalidaNO,			Par_NumErr,         Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,    
                    Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);

				UPDATE SOLICITUDCREDITO SET
					TasaFija = Var_TasaFija,
					NivelID = IFNULL(Var_NivelID,Entero_Cero),
					NumTransacSim   = Entero_Cero
					WHERE SolicitudCreditoID = Par_Solicitud;

            END IF;


		END IF;
	END IF;

	SET Par_NumErr := 0;
	SET Par_ErrMen := "Integrante de Grupo Actualizado";

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Entero_Cero AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$