-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALIDAPRODCREDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `VALIDAPRODCREDPRO`;
DELIMITER $$

CREATE PROCEDURE `VALIDAPRODCREDPRO`(
/*SP DE VALIDACION DE PRODUCTO DE CRÉDITO*/
    Par_CreditoID       BIGINT(12),
    Par_SolicitudID     INT(11),
    Par_TipoValida      INT(11),
    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),

    INOUT Par_ErrMen    VARCHAR(400),
    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),

    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11) ,
    Aud_NumTransaccion  BIGINT(20)
		)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_ReqAvales   	CHAR(1);
	DECLARE Var_Cuenta      	INT(11);
	DECLARE Var_ReqGarant   	CHAR(1);
	DECLARE Var_RelGarCred  	DECIMAL(14,2);
	DECLARE Var_ResMonGaran 	DECIMAL(14,2);
	DECLARE Var_ReqGarLiq   	CHAR(1);
	DECLARE Var_PorGarLiq  	 	DECIMAL(12,4);
	DECLARE Var_GarLiqDep		DECIMAL(14,2);
	DECLARE Var_ForCobCoAp  	CHAR(1);
	DECLARE Var_MonComApe   	DECIMAL(14,2);
	DECLARE Var_ComApePag   	DECIMAL(14,2);
	DECLARE Var_Producto		INT(11);
	DECLARE Var_NumAvaCap		INT(11);
	DECLARE Var_NumAvaAut		INT(11);
	DECLARE Var_AvaInCap		INT(11); -- Almacena si se Capturaron Avales cuando Requiere Avales es Indistinto
	DECLARE Var_GaraInCap		INT(11); -- Almacena si se Capturaron Garantias cuando Requiere Garantias es Indistinto
	DECLARE Var_MonSegVida		DECIMAL(14,2);
	DECLARE Var_SegVidaPag		DECIMAL(14,2);
	DECLARE Var_ForCobSVida		CHAR(1);
	DECLARE Var_ReqReferencias	CHAR(1);
	DECLARE Var_MontoCred   	DECIMAL(14,2);
	DECLARE Var_NumGarCap   	INT(11);
	DECLARE Var_NumGarAut   	INT(11);
	DECLARE Var_NumRefer		INT(11);
	DECLARE Var_SumGarAsi		DECIMAL(14,2);
	DECLARE Var_AporteCli		DECIMAL(12,2);
    DECLARE Var_Control			VARCHAR(20);	-- Campo para el id del control de pantalla
	DECLARE Var_Consecutivo		VARCHAR(50);	-- Campo consecutivo del control de pantalla
    DECLARE Var_MinReferencias	INT(11);		-- Minimo de referencias
	DECLARE Var_MontoSustituye	DECIMAL(14,2);	-- Monto que sustituye a la GL
	DECLARE Var_EsAgropecuario	CHAR(1);		-- Indica si el producto de credito es agro
	DECLARE	Var_NumOSolidCap	INT(11)	;			-- Almacena el numero de obligados Solidarios capturados para una solicitud de credito
	DECLARE	Var_NumOSolidAut	INT(11)	;			-- Almacena el numero de obligados Solidarios autorizados para una solicitud de credito
    DECLARE Var_CobraAccesorios	CHAR(1);	-- Indica si se realizara el cobro de accesorios
    DECLARE Var_NumRegistros	INT(11);		-- Numero de Registros que su accesorio no ha sido cobrado

	-- Declaracion de constantes
    DECLARE Var_CobraGarFin			CHAR(1);
    DECLARE Var_RequiereGarFOGAFI	CHAR(1);
    DECLARE Var_ModalidadFOGAFI		CHAR(1);
    DECLARE Var_FechaLiqGarFOGAFI	DATE;
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Fecha_Vacia				DATE;
	DECLARE TipoValiAltaCre			INT(11);
	DECLARE TipoValiAutCre			INT(11);
	DECLARE TipoValiLiberaSol		INT(11);
	DECLARE SalidaSI				CHAR(1);
	DECLARE SalidaNO				CHAR(1);
	DECLARE EstCerrGrup				CHAR(1);
	DECLARE ReqAvalesSi				CHAR(1);
	DECLARE Indistinto				CHAR(1);
	DECLARE Est_AutAval				CHAR(1);
	DECLARE Est_AutGaran			CHAR(1);
	DECLARE ValorSI					CHAR(1);
	DECLARE ForCobCoApAdel			CHAR(1);
	DECLARE ForCoSegOtro			CHAR(1);
	DECLARE Var_ReqObliSol			CHAR(1);			-- Almacena la parametrizacion de si requiere Obligados Solidarios
	DECLARE Est_AutOSolidario		CHAR(1);			-- Almacena el estatus de autorizado para los obligados solidarios
	DECLARE ForCobroAnticipado		CHAR(1);			-- Forma de cobro del accesorio: D:Deduccion
	DECLARE LlaveCobraAccesorios	VARCHAR(200);	-- Llave para Consultar Si Cobra Accesorios
	DECLARE LlaveGarFinanciada		VARCHAR(100);
	DECLARE	Var_PerConsolidacion	CHAR(1);			-- El producto permite consolidación
	DECLARE Var_ReqInsDispersion	CHAR(1);			-- El producto requiere instrucciones de Dispersión
	DECLARE Var_EstatusR			CHAR(1);			-- El producto requiere instrucciones de Dispersión

	-- Asignacion de Variables
	SET Var_AvaInCap		:= 0;
	SET Var_GaraInCap		:= 0;

	-- Asignacion de constantes
	SET Cadena_Vacia        := '';              -- Cadena Vacia
	SET Fecha_Vacia         := '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero         := 0;               -- Entero en Cero

	SET TipoValiAltaCre     := 1;               -- validaciones de alta de credito
	SET TipoValiAutCre      := 2;               -- validaciones de autorizacion de credito
	SET TipoValiLiberaSol   := 4;               -- Validaciones para liberar Solicitudes de credito

	SET SalidaSI            := 'S';             -- El store SI arroja una Salida
	SET SalidaNO            := 'N';             -- El store NO arroja una Salida
	SET EstCerrGrup         := 'C';             -- Estatus del Grupo Cerrado
	SET ReqAvalesSi         := 'S';             -- Requiere Avales: SI
	SET Indistinto	 		:= 'I';				-- Requiere Avales o Requiere Garantias : Indistinto
	SET Est_AutAval         := 'U';             -- Estatus del Aval: Autorizado
	SET Est_AutGaran        := 'U';             -- Estatus de la Garantia: Autorizada
	SET Est_AutOSolidario	:= 'U';				-- Estatus de autorizado

	SET ValorSI					:= 'S';							-- Variable SI
	SET ForCobCoApAdel			:= 'A';							-- Forma de Cobro de la ComxApertura: Anticipado
	SET ForCoSegOtro			:= 'O';							-- Forma de Cobro de Seguro de vida: Otro
	SET Var_MinReferencias		:= 0;							-- Minimo de Referencias
	SET Var_Control				:= 'solicitudCreditoID';
	SET Var_Consecutivo			:= 0;
	SET ForCobroAnticipado		:= 'A';							-- Forma de Cobro de Accesorios. A: Anticipado
	SET LlaveCobraAccesorios	:= 'CobraAccesorios';			-- Llave que indica el cobro Accesorios
	SET LlaveGarFinanciada		:= 'CobraGarantiaFinanciada';
	SET Var_EstatusR			:= 'R';							-- Estatus R de Dispersión Registrada

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-VALIDAPRODCREDPRO');
			SET Var_Control:= 'SQLEXCEPTION';
		END;

		-- Validaciones Alta de Credito
		IF(Par_TipoValida = TipoValiAltaCre) THEN
			IF(Par_SolicitudID != Entero_Cero) THEN
				-- Obtiene Producto de Credito
				SET Var_Producto := (SELECT IFNULL(ProductoCreditoID, Entero_Cero)
					FROM SOLICITUDCREDITO
					WHERE SolicitudCreditoID = Par_SolicitudID);
				SET Var_MontoCred := (SELECT IFNULL(MontoAutorizado,Entero_Cero)
					FROM SOLICITUDCREDITO
					WHERE SolicitudCreditoID = Par_SolicitudID);

				-- Revisa si el producto de credito requiere avales, en caso de ser asi verifica
				-- si ya estan registrados
				SELECT
						RequiereAvales,				RequiereGarantia,	RelGarantCred,		RequiereReferencias,	EsAgropecuario,
						ReqObligadosSolidarios,		PerConsolidacion,	ReqInsDispersion
						INTO
						Var_ReqAvales,		Var_ReqGarant,			Var_RelGarCred,			Var_ReqReferencias,		Var_EsAgropecuario,
						Var_ReqObliSol,		Var_PerConsolidacion,	Var_ReqInsDispersion
					FROM	PRODUCTOSCREDITO
					WHERE ProducCreditoID = Var_Producto;

				SET Var_ReqAvales			:= IFNULL(Var_ReqAvales, Cadena_Vacia);
				SET Var_ReqGarant			:= IFNULL(Var_ReqGarant, Cadena_Vacia);
				SET Var_RelGarCred			:= IFNULL(Var_RelGarCred,Entero_Cero);
				SET Var_ReqReferencias		:= IFNULL(Var_ReqReferencias,Entero_Cero);
				SET Var_EsAgropecuario		:= IFNULL(Var_EsAgropecuario, SalidaNO);
				SET Var_ReqObliSol			:= IFNULL(Var_ReqObliSol,SalidaNO);
				SET Var_PerConsolidacion	:= IFNULL(Var_PerConsolidacion, Cadena_Vacia);
				SET Var_ReqInsDispersion	:= IFNULL(Var_ReqInsDispersion, Cadena_Vacia);

				-- Valida si el priducto Requiere Instrucciones de Dispersión
					IF (Var_ReqInsDispersion = ValorSI) THEN

						IF EXISTS(SELECT Estatus
										FROM INSTRUCDISPERSIONCRE
									   WHERE Estatus = Var_EstatusR
										 AND SolicitudCreditoID = Par_SolicitudID) THEN

						SET Par_NumErr := 10;
						SET	Par_ErrMen := CONCAT("Las instrucciones de Dispersión relacionados a la Solicitud, no han sido autorizadas: ",CONVERT(Par_SolicitudID, CHAR)) ;
						LEAVE TerminaStore;

						END IF;
					END IF;




				IF(Var_ReqObliSol = ValorSI OR Var_ReqObliSol = Indistinto) THEN
					-- Se cuenta cuantos Obligados solidarios fueron capturados y autorizados
					SELECT COUNT(SolicitudCreditoID), IF(MAX(Estatus) = Est_AutOSolidario, 1,0)
					INTO	Var_NumOSolidCap,	Var_NumOSolidAut
					FROM OBLSOLIDARIOSPORSOLI
					WHERE SolicitudCreditoID = Par_SolicitudID ;
				END IF;

				SET Var_NumOSolidCap	:= IFNULL(Var_NumOSolidCap, Entero_Cero);
				SET Var_NumOSolidAut	:= IFNULL(Var_NumOSolidAut, Entero_Cero);

				-- SE VALIDA SI REQUIERE OBLIGADOS SOLIDAROS, SE TENGA POR LO MENOS UNO CAPTURADO
				IF( Var_ReqObliSol = ValorSI) THEN
					IF( Var_NumOSolidCap <= Entero_Cero) THEN
						SET Par_NumErr := 004;
						SET	Par_ErrMen := CONCAT("No Existen Obligados solidarios Relacionados a la Solicitud: ",CONVERT(Par_SolicitudID, CHAR)) ;
						LEAVE TerminaStore;
					END IF;
				END IF;

				-- SE VALIDA SI SE HA CAPTURADO X LO MENOS UN OBLIGADO SOLIDARIO, ESTE AUTORIZADO
				IF( Var_ReqObliSol = Indistinto OR Var_ReqObliSol = ValorSI ) THEN
					IF( Var_NumOSolidCap > Entero_Cero AND Var_NumOSolidAut = Entero_Cero) THEN
							SET Par_NumErr := 005;
							SET	Par_ErrMen := CONCAT("Los Obligados solidarios Relacionados a la Solicitud: ",CONVERT(Par_SolicitudID, CHAR), " no estan autorizados") ;
							LEAVE TerminaStore;
					END IF;
				END IF;

				IF(Var_ReqAvales = ReqAvalesSi OR Var_ReqAvales=Indistinto) THEN

					IF(Var_ReqAvales=Indistinto) THEN
						SELECT COUNT(SolicitudCreditoID)
							INTO  Var_NumAvaCap
						FROM	AVALESPORSOLICI
						WHERE SolicitudCreditoID = Par_SolicitudID;

					SET Var_NumAvaCap   := IFNULL(Var_NumAvaCap, Entero_Cero);

					IF(Var_NumAvaCap>Entero_Cero) THEN
						SET Var_AvaInCap=1;
					END IF;

				END IF;

				IF(Var_ReqAvales = ReqAvalesSi OR Var_AvaInCap>Entero_Cero) THEN

					SELECT COUNT(SolicitudCreditoID),
						   SUM(CASE Estatus
									WHEN Est_AutAval THEN 1
									ELSE 0
								END) INTO
							Var_NumAvaCap, Var_NumAvaAut
						FROM	AVALESPORSOLICI
						WHERE SolicitudCreditoID = Par_SolicitudID;

					SET Var_NumAvaCap   := IFNULL(Var_NumAvaCap, Entero_Cero);
					SET Var_NumAvaAut   := IFNULL(Var_NumAvaAut, Entero_Cero);

					IF( Var_NumAvaCap = Entero_Cero) THEN

							IF(Par_Salida = SalidaSI) THEN
								SELECT  '001' AS NumErr,
									CONCAT("No Existen Avales Relacionados a la Solicitud: ",
									 CONVERT(Par_SolicitudID, CHAR)) AS ErrMen,
									'' AS control,
									Par_SolicitudID AS consecutivo;
								LEAVE TerminaStore;
							END IF;
							IF(Par_Salida = SalidaNO) THEN
								SET Par_NumErr := 1;
								SET	Par_ErrMen := CONCAT("No Existen Avales Relacionados a la Solicitud: ",
													   CONVERT(Par_SolicitudID, CHAR)) ;
								LEAVE TerminaStore;
							END IF;
							ELSE
								SET Par_NumErr := 0;
					END IF;

					IF(Var_NumAvaAut = Entero_Cero) THEN
						IF(Par_Salida = SalidaSI) THEN
								SELECT  '002' AS NumErr,
								   CONCAT("Los Avales Relacionados a la Solicitud: ",
											CONVERT(Par_SolicitudID, CHAR)," No Estan Autorizados.") AS ErrMen,
								   Cadena_Vacia AS control,
									Par_SolicitudID AS consecutivo;
								LEAVE TerminaStore;
							END IF;
							IF(Par_Salida = SalidaNO) THEN
								SET Par_NumErr := 2;
								SET Par_ErrMen := CONCAT("Los Avales Relacionados a la Solicitud: ",
													CONVERT(Par_SolicitudID, CHAR)," No Estan Autorizados.");
								LEAVE TerminaStore;
							END IF;
							ELSE
								SET Par_NumErr := 0;
						END IF;
					END IF;
				END IF;
				-- Validacion de las Garantias, si es que son Requeridas
				IF(Var_ReqGarant = ValorSI OR Var_ReqGarant=Indistinto) THEN

					IF(Var_ReqGarant=Indistinto) THEN

					SELECT COUNT(SolicitudCreditoID)
							INTO    Var_NumGarCap
							FROM	ASIGNAGARANTIAS
							WHERE SolicitudCreditoID = Par_SolicitudID;

					SET Var_NumGarCap   := IFNULL(Var_NumGarCap, Entero_Cero);

					IF(Var_NumGarCap>Entero_Cero) THEN
						SET Var_GaraInCap=1;
					END IF;

				END IF;

				IF(Var_ReqGarant = ValorSI OR Var_GaraInCap>Entero_Cero) THEN
					SELECT COUNT(SolicitudCreditoID),
									SUM(CASE Estatus
										WHEN Est_AutGaran THEN 1
										ELSE 0
									END),
									SUM(CASE Estatus
										WHEN Est_AutGaran THEN MontoAsignado
										ELSE 0
									END) INTO
								Var_NumGarCap, Var_NumGarAut, Var_SumGarAsi
							FROM	ASIGNAGARANTIAS
							WHERE SolicitudCreditoID = Par_SolicitudID;

					SET Var_NumGarCap   := IFNULL(Var_NumGarCap, Entero_Cero);
					SET Var_NumGarAut   := IFNULL(Var_NumGarAut, Entero_Cero);
					SET Var_SumGarAsi   := IFNULL(Var_SumGarAsi, Entero_Cero);


						--  Cuando no hay registro de garantias relacionadas a la solicitud
					IF (Var_NumGarCap = Entero_Cero)  THEN

							IF(Par_Salida =SalidaSI) THEN
								SELECT  '003' AS NumErr,
								   CONCAT("No Existen Garantias Relacionadas a la Solicitud: ",
										   CONVERT(Par_SolicitudID, CHAR)) AS ErrMen,
								   '' AS control,
								   Par_SolicitudID AS consecutivo;
							LEAVE TerminaStore;
						END IF;
							IF(Par_Salida = SalidaNO) THEN
								SET Par_NumErr := 3;
								SET Par_ErrMen := CONCAT("No Existen Garanti­as Relacionadas a la Solicitud: ",
													CONVERT(Par_SolicitudID, CHAR));
								LEAVE TerminaStore;
							END IF;
					END IF;

					--  Cuando las garantias relacionadas a la solicitud no estan  autorizadas
					IF (Var_NumGarAut = Entero_Cero)  THEN

							IF(Par_Salida = SalidaSI) THEN
							SELECT  '004' AS NumErr,
								   CONCAT("Las Garantias Relacionadas a la Solicitud: ",
										   CONVERT(Par_SolicitudID, CHAR)," No han sido Autorizadas.") AS ErrMen,
								   Cadena_Vacia AS control,
								   Par_SolicitudID AS consecutivo;
							LEAVE TerminaStore;
							END IF;

							IF(Par_Salida = SalidaNO) THEN
								SET Par_NumErr := 4;
								SET Par_ErrMen := CONCAT("Las Garantias Relacionadas a la Solicitud: ",
													CONVERT(Par_SolicitudID, CHAR)," No han sido Autorizadas.");
								LEAVE TerminaStore;
							END IF;

					END IF;

					-- Calcula el monto de relacion de la garantia
					SET Var_ResMonGaran := (Var_MontoCred * (Var_RelGarCred/100.00));

					IF(Var_SumGarAsi < Var_ResMonGaran)THEN

						IF(Par_Salida = SalidaSI) THEN
							SELECT  '005' AS NumErr,
									CONCAT("El Monto de la(s) Garanti­a(s) Asociada(s) a la Solicitud ",
											CONVERT(Par_SolicitudID, CHAR),
											" es menor al Grado de Cobertura Requerido") AS ErrMen,
									Cadena_Vacia AS control,
									Par_SolicitudID AS consecutivo;
							LEAVE TerminaStore;
						END IF;
						IF(Par_Salida =SalidaNO) THEN
							SET Par_NumErr := 5;
							SET Par_ErrMen :=   CONCAT("El Monto de la(s) Garanti­a(s) Asociada(s) a la Solicitud ",
												   CONVERT(Par_SolicitudID, CHAR),
												   " es menor al Grado de Cobertura Requerido") ;
							LEAVE TerminaStore;
						END IF;
					ELSE
						SET Par_NumErr := 0;
					END IF;

				END IF;

			END IF; -- fin solicitud
				-- Validacion de las referencias, si es que son requeridas
				IF(Var_ReqReferencias = Var_ReqReferencias OR Var_ReqReferencias=Indistinto) THEN
					SET Var_NumRefer :=(SELECT COUNT(SolicitudCreditoID)
										FROM REFERENCIACLIENTE
											WHERE SolicitudCreditoID=Par_SolicitudID);
					SET Var_NumRefer   := IFNULL(Var_NumRefer, Entero_Cero);
					IF(Var_NumRefer>Entero_Cero) THEN
						SET Var_NumRefer :=1;
					END IF;
				END IF;
				SET Par_NumErr  := Entero_Cero;
				SET Par_ErrMen  := CONCAT("Validaciones Realizadas con Exito");
				SET Var_Control := 'creditoID';
				SET Var_Consecutivo := Par_CreditoID;
				LEAVE ManejoErrores;
			END IF;
		END IF;-- fin validacion alta credito

		-- Validaciones en la Autorizacion del Credito
		IF(Par_TipoValida = TipoValiAutCre) THEN

			SELECT ValorParametro INTO Var_CobraAccesorios FROM PARAMGENERALES WHERE LlaveParametro = LlaveCobraAccesorios;
			-- Inicializacion
			SET Var_CobraGarFin := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = LlaveGarFinanciada);
			SET Var_CobraGarFin := IFNULL(Var_CobraGarFin, Cadena_Vacia);
			SET Var_GarLiqDep   := Entero_Cero;
			SET Var_MonComApe   := Entero_Cero;

			-- Suma los montos de garantia liquida depositado
			CALL CREGARLIQCON (
				Par_CreditoID,		SalidaNO,			Var_GarLiqDep,		Par_NumErr,			Par_ErrMen,
				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion );

			SET Var_GarLiqDep := IFNULL(Var_GarLiqDep, Entero_Cero);

			SELECT MontoCredito,        ForCobroComAper,	MontoComApert, ComAperPagado, MontoSeguroVida,
				   SeguroVidaPagado,    ForCobroSegVida, 	AporteCliente INTO

				   Var_MontoCred,       Var_ForCobCoAp,		Var_MonComApe, Var_ComApePag, Var_MonSegVida,
				   Var_SegVidaPag, 		Var_ForCobSVida,	Var_AporteCli

				FROM CREDITOS
				WHERE CreditoID = Par_CreditoID;

			SET Var_AporteCli := IFNULL(Var_AporteCli,Entero_Cero);

            -- Valida el producto para realizar la suma de montos correspondientes
            IF( Var_EsAgropecuario = SalidaNO )THEN
				-- Valida si el monto de garantia liquida ya fue depositado
				IF(Var_GarLiqDep < Var_AporteCli) THEN
					SET	Par_NumErr	:= 001;
					SET	Par_ErrMen	:= CONCAT('El Monto de Garantia Liquida Asociado al Credito ',
										CONVERT(Par_CreditoID, CHAR), ' no ha sido Cubierto ');
					SET Var_Control	:= 'solicitudCreditoID';
					SET Var_Consecutivo := Par_SolicitudID;
					LEAVE ManejoErrores;
				END IF;
			ELSE
				 /*OBTENER MONTO DE LAS GARANTIAS QUE SUSTITUYEN GL*/
				SELECT SUM(MontoAsignado) INTO Var_MontoSustituye FROM ASIGNAGARANTIAS
					WHERE SolicitudCreditoID=Par_SolicitudID
						AND SustituyeGL=SalidaSI;

				SET Var_MontoSustituye:= IFNULL(Var_MontoSustituye,Entero_Cero)+Var_GarLiqDep;

				IF(Var_MontoSustituye < Var_AporteCli) THEN
					SET	Par_NumErr	:= 001;
					SET	Par_ErrMen	:= CONCAT('El Monto de Garantia Liquida Asociado al Credito ',
										CONVERT(Par_CreditoID, CHAR), ' no ha sido Cubierto ');
					SET Var_Control	:= 'solicitudCreditoID';
					SET Var_Consecutivo := Par_SolicitudID;
					LEAVE ManejoErrores;
				END IF;
            END IF;

			-- Valida Si la forma de pago de Comision por apertura es por Adelantado
			-- Valida que haya sido depositada
			IF(Var_ForCobCoAp = ForCobCoApAdel AND Var_ComApePag < Var_MonComApe) THEN
				SET	Par_NumErr	:= 002;
				SET	Par_ErrMen	:= CONCAT('El Monto de Comision por Apertura Asociado al Credito ',
									CONVERT(Par_CreditoID, CHAR), ' no ha sido Cubierto ');
				SET Var_Control	:= 'solicitudCreditoID';
				SET Var_Consecutivo := Par_SolicitudID;
				LEAVE ManejoErrores;
			END IF;


			-- Valida Si la forma de pago del Seguro de vida es por Adelantado
			-- Valida que haya sido Depositada
		   IF(Var_ForCobSVida = ForCobCoApAdel AND Var_SegVidaPag < Var_MonSegVida) THEN
				SET	Par_NumErr	:= 003;
				SET	Par_ErrMen	:= CONCAT("El Monto del Seguro de Vida Relacionado al Credito ",
									CONVERT(Par_CreditoID, CHAR), " no ha sido Cubierto ");
				SET Var_Control	:= 'monto';
				SET Var_Consecutivo := 0;
				LEAVE ManejoErrores;
			END IF;


		   IF( Var_ForCobSVida = ForCoSegOtro AND Var_SegVidaPag < Var_MonSegVida) THEN
				SET	Par_NumErr	:= 004;
				SET	Par_ErrMen	:= CONCAT("El Monto del Seguro de Vida Relacionado al Credito ",
									CONVERT(Par_CreditoID, CHAR), " no ha sido Cubierto ");
				SET Var_Control	:= 'solicitudCreditoID';
				SET Var_Consecutivo := Par_SolicitudID;
				LEAVE ManejoErrores;
			END IF;

			IF(Var_CobraAccesorios = ValorSI) THEN
				SET Var_NumRegistros := (SELECT COUNT(*) FROM DETALLEACCESORIOS
											WHERE CreditoID	= Par_CreditoID
												AND TipoFormaCobro 	= ForCobroAnticipado
                                                AND FechaLiquida 	= Fecha_Vacia);
				IF(Var_NumRegistros > Entero_Cero) THEN
					SET	Par_NumErr	:= 005;
					SET	Par_ErrMen	:= CONCAT('El Monto de Accesorios Asociado al Credito ',
										CONVERT(Par_CreditoID, CHAR), ' no ha sido Cubierto ');
					SET Var_Control	:= 'creditoID';
					SET Var_Consecutivo := Par_CreditoID;
					LEAVE ManejoErrores;
                END IF;

            END IF;
            IF(Var_CobraGarFin = ValorSI) THEN

                SELECT RequiereGarFOGAFI, ModalidadFOGAFI,	FechaLiquidaFOGAFI INTO Var_RequiereGarFOGAFI, Var_ModalidadFOGAFI,	Var_FechaLiqGarFOGAFI
				FROM DETALLEGARLIQUIDA WHERE CreditoID = Par_CreditoID;

                IF(Var_RequiereGarFOGAFI = ValorSI AND Var_ModalidadFOGAFI = ForCobroAnticipado AND Var_FechaLiqGarFOGAFI = Fecha_Vacia) THEN
					SET	Par_NumErr	:= 006;
					SET	Par_ErrMen	:= CONCAT('El Monto de Garantia FOGAFI Asociado al Credito ',
										CONVERT(Par_CreditoID, CHAR), ' no ha sido Cubierto ');
					SET Var_Control	:= 'creditoID';
					SET Var_Consecutivo := Par_CreditoID;
					LEAVE ManejoErrores;
                END IF;

            END IF;

			SET Par_NumErr  := Entero_Cero;
			SET Par_ErrMen  := CONCAT("Validaciones Realizadas con exito");
			SET Var_Control	:= 'solicitudCreditoID';
			SET Var_Consecutivo := Par_SolicitudID;
			LEAVE ManejoErrores;
		END IF; -- Fin Validacion Autorizacion del Credito

		-- Validaciones al Liberar la solicitud
		IF(Par_TipoValida = TipoValiLiberaSol) THEN
			/* NO CAMBIAR LOS SET AL ASIGNAR VALORES POR INTO PORQUE ESTA
				SECCION SE OCUPA DENTRO DE UN CURSOR .*/
		--
			SET Var_Producto	:= (SELECT IFNULL(ProductoCreditoID, Entero_Cero)
										FROM SOLICITUDCREDITO
										WHERE SolicitudCreditoID = Par_SolicitudID);

			SET Var_MontoCred	:= (SELECT IFNULL(MontoAutorizado,Entero_Cero)
										FROM SOLICITUDCREDITO
										WHERE SolicitudCreditoID = Par_SolicitudID);


			SET Var_ReqAvales := (SELECT RequiereAvales
									FROM	PRODUCTOSCREDITO
									WHERE ProducCreditoID = Var_Producto);

			SET Var_ReqGarant := (SELECT RequiereGarantia
									FROM	PRODUCTOSCREDITO
									WHERE ProducCreditoID = Var_Producto);

			SET Var_RelGarCred	:= (SELECT RelGarantCred
									FROM	PRODUCTOSCREDITO
									WHERE ProducCreditoID = Var_Producto);

            SET Var_ReqReferencias:= (SELECT RequiereReferencias
										FROM	PRODUCTOSCREDITO
										WHERE ProducCreditoID = Var_Producto);

            SET Var_MinReferencias:= (SELECT MinReferencias
										FROM	PRODUCTOSCREDITO
										WHERE ProducCreditoID = Var_Producto);

			SET Var_ReqObliSol := (SELECT ReqObligadosSolidarios
									FROM	PRODUCTOSCREDITO
									WHERE ProducCreditoID = Var_Producto);



			SET Var_ReqAvales		:= IFNULL(Var_ReqAvales,Cadena_Vacia);
			SET Var_ReqGarant		:= IFNULL(Var_ReqGarant,Cadena_Vacia);
			SET Var_RelGarCred		:= IFNULL(Var_RelGarCred, Entero_Cero);
			SET Var_ReqReferencias  := IFNULL(Var_ReqReferencias, Cadena_Vacia);
			SET Var_ReqObliSol		:=IFNULL(Var_ReqObliSol,SalidaNO);

			IF(Var_ReqObliSol = ValorSI) THEN
					-- Se cuenta cuantos Obligados solidarios fueron capturados
				SET Var_NumOSolidCap := (SELECT COUNT(SolicitudCreditoID) FROM OBLSOLIDARIOSPORSOLI 	WHERE SolicitudCreditoID = Par_SolicitudID );
				SET Var_NumOSolidCap := IFNULL(Var_NumOSolidCap, Entero_Cero);

				IF( Var_NumOSolidCap <=0 ) THEN
					SET Par_NumErr := 004;
					SET	Par_ErrMen := CONCAT("No Existen Obligados solidarios Relacionados a la Solicitud: ",CONVERT(Par_SolicitudID, CHAR)) ;
					LEAVE TerminaStore;
				END IF;
			END IF;

			IF(Var_ReqAvales = ReqAvalesSi OR Var_ReqAvales=Indistinto) THEN
				IF(Var_ReqAvales=ReqAvalesSi)THEN
					IF NOT EXISTS( SELECT SolicitudCreditoID
									FROM	AVALESPORSOLICI
									WHERE SolicitudCreditoID = Par_SolicitudID ) THEN
						SET	Par_NumErr	:= 001;
						SET	Par_ErrMen	:= CONCAT("No Existen Avales Relacionados a la Solicitud: ",
												   CONVERT(Par_SolicitudID, CHAR));
						SET Var_Control	:= 'solicitudCreditoID';
						SET Var_Consecutivo := Par_SolicitudID;
						LEAVE ManejoErrores;
					END IF;
				END IF;
			 END IF;

			IF(Var_ReqGarant = ValorSI  OR Var_ReqGarant=Indistinto)THEN
				IF(Var_ReqGarant=ValorSI)THEN
					SET Var_SumGarAsi := (SELECT SUM(MontoAsignado)
											FROM	ASIGNAGARANTIAS
											WHERE SolicitudCreditoID = Par_SolicitudID
											GROUP BY SolicitudCreditoID);

					SET Var_NumGarCap := (SELECT COUNT(SolicitudCreditoID)
												FROM	ASIGNAGARANTIAS
												WHERE SolicitudCreditoID = Par_SolicitudID
												GROUP BY SolicitudCreditoID);

					SET Var_SumGarAsi  := IFNULL(Var_SumGarAsi, Entero_Cero);
					SET Var_NumGarCap   := IFNULL(Var_NumGarCap, Entero_Cero);

					IF (Var_NumGarCap <= Entero_Cero) THEN
						SET	Par_NumErr	:= 001;
						SET Par_ErrMen  := CONCAT("No Existen Garantias Relacionadas a la Solicitud: ",
												   CONVERT(Par_SolicitudID, CHAR));
						SET Var_Control	:= 'solicitudCreditoID';
						SET Var_Consecutivo := Par_SolicitudID;
						LEAVE ManejoErrores;
					END IF;

					IF (Var_SumGarAsi <= Entero_Cero) THEN
						SET	Par_NumErr	:= 001;
						SET Par_ErrMen  := CONCAT("La suma de montos de las Garantias Autorizadas Relacionadas a
												   la Solicitud: ", CONVERT(Par_SolicitudID, CHAR),
													" no debe ser igual a cero");
						SET Var_Control	:= 'solicitudCreditoID';
						SET Var_Consecutivo := Par_SolicitudID;
						LEAVE ManejoErrores;
					END IF;

					-- Calcula el monto de relacion Garantia
					SET Var_ResMonGaran := (Var_MontoCred * (Var_RelGarCred/100.00));

					IF(Var_SumGarAsi < Var_ResMonGaran) THEN
						SET	Par_NumErr	:= 001;
						SET Par_ErrMen  := CONCAT("El Monto de la(s) Garanti­a(s) Asociada(s) a la Solicitud ",
												   CONVERT(Par_SolicitudID, CHAR),
												   " es menor al Grado de Cobertura Requerido");
						SET Var_Control	:= 'solicitudCreditoID';
						SET Var_Consecutivo := Par_SolicitudID;
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;
			IF(Var_ReqReferencias = ValorSI  OR Var_ReqReferencias=Indistinto)THEN
				IF(Var_ReqReferencias=ValorSI)THEN

					SET Var_NumRefer :=(SELECT COUNT(SolicitudCreditoID)
										FROM REFERENCIACLIENTE
											WHERE SolicitudCreditoID=Par_SolicitudID
                                            AND Validado=ValorSI
                                            GROUP BY SolicitudCreditoID);
					SET Var_NumRefer   := IFNULL(Var_NumRefer, Entero_Cero);

					IF (Var_NumRefer < Var_MinReferencias) THEN
						SET	Par_NumErr	:= 001;
						SET Par_ErrMen  := CONCAT("La Solicitud no Cumple con el Minimo de Referencias Validadas: ",
												   CONVERT(Par_SolicitudID, CHAR));
						SET Var_Control	:= 'solicitudCreditoID';
						SET Var_Consecutivo := Par_SolicitudID;
						LEAVE ManejoErrores;
					END IF;

				END IF;
			END IF;
			SET Par_NumErr  := Entero_Cero;
			SET Par_ErrMen  := CONCAT("Validaciones Realizadas con Exito");
			SET Var_Control	:= 'solicitudCreditoID';
			SET Var_Consecutivo := Par_SolicitudID;
			LEAVE ManejoErrores;
		END IF;
	END ManejoErrores;

    IF(Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;
END TerminaStore$$