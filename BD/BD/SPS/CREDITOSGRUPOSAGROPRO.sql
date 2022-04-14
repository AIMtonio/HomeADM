-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSGRUPOSAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSGRUPOSAGROPRO`;
DELIMITER $$


CREATE PROCEDURE `CREDITOSGRUPOSAGROPRO`(
# =====================================================================================
# ----- STORE PARA AUTORIZAR IMPRIMIR PAGARE Y DESEMBOLSAR CREDITOS GRUPALES  --
# =====================================================================================
    Par_GrupoID             INT(11),                -- ID del grupo
    Par_FechaMinistra		DATE,					-- Fecha de Ministracion
    Par_PolizaID            BIGINT(20),             -- ID de la poliza
    Par_TipoActualiza       TINYINT UNSIGNED,       -- Numero de Actualizacion
	Par_OrigenPago			CHAR(1),				-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
    Par_Salida              CHAR(1),                -- indica una salida
    INOUT   Par_NumErr      INT(11),                -- parametro numero de error
    INOUT   Par_ErrMen      VARCHAR(400),           -- mensaje de error

    Par_EmpresaID           INT(11),                -- parametros de auditoria
    Aud_Usuario             INT(11),                -- parametros de auditoria
    Aud_FechaActual         DATETIME ,              -- parametros de auditoria
    Aud_DireccionIP         VARCHAR(15),            -- parametros de auditoria
    Aud_ProgramaID          VARCHAR(50),            -- parametros de auditoria
    Aud_Sucursal            INT(11),                -- parametros de auditoria
    Aud_NumTransaccion      BIGINT(20)              -- parametros de auditoria
)

TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE	Var_EsDiaHabil			CHAR(1);
	DECLARE Var_CalculoInt			CHAR(1);			-- Tipo de Calculo de interes fechaPactada	: P, fechaReal: R
	DECLARE Var_ClienteID           INT(11);            -- Id del cliente
	DECLARE Var_Consecutivo         BIGINT(12);         -- Consecutivo
	DECLARE Var_ConsecutivoID		INT(11);			-- ID consecutivo de tabla temporal
	DECLARE Var_Control             VARCHAR(50);        -- Variable de control.
	DECLARE Var_CreditoID           BIGINT(12);         -- ID del credito
	DECLARE Var_CreditoPasivoID		BIGINT(20);			-- Numero de credito Pasivo
	DECLARE Var_CuentaID            BIGINT(12);         -- ID de la cuenta
	DECLARE Var_DiasMaxMinPos		INT(11);			-- Dias maximos permitidos para desembolsar
	DECLARE Var_EstatusC            CHAR(1);            -- Estatus del credito
	DECLARE Var_EstatusCiclo        CHAR(1);            -- Estatus del ciclo actual del grupo
	DECLARE Var_FechaCalculo		DATE;				-- Fecha de Calculo
	DECLARE Var_FechaFinal			DATE;
	DECLARE Var_FechaInicio			DATE;				-- Fecha de inicio del credito
	DECLARE Var_FechaMinistracion	DATE;				-- Fecha de la primer ministracion de los creditos grupales
	DECLARE Var_FechaSis            DATE;               -- Fecha del sistema
	DECLARE Var_GrupoID             INT(11);            -- ID del grupo
	DECLARE Var_MontoPago           DECIMAL(12,2);      -- Monto del Pago
	DECLARE Var_NumIntegrantes    	INT(11);            -- NUmero de integrantes Grupo
	DECLARE Var_Poliza              BIGINT(12);         -- Numero de Poliza
	DECLARE Var_ProductoCreditoID   INT(11);            -- Producto de credito
	DECLARE Var_SaldoDispo          DECIMAL(12,2);      -- Saldo disponible de la cuenta
	DECLARE Var_Solicitud			INT(11);			-- ID de la solicitud de credito
	DECLARE Var_TipoCredito         INT(11);            -- Tipo de Credito
	DECLARE Var_TipoPrepago         CHAR(1);            -- Tipo de prepago
	DECLARE Var_UsuarioID           INT(11);            -- Usuario ID

	-- Declaracion de Constantes
	DECLARE Entero_Cero         INT(11);                -- entero cero
	DECLARE Entero_Uno          INT(11);                -- entero uno
	DECLARE Decimal_Cero        DECIMAL(14,2);          -- DECIMAL Cero
	DECLARE Salida_SI           CHAR(1);                -- salida SI
	DECLARE Fecha_Vacia         DATE;                   -- Fecha vacia
	DECLARE Cadena_Vacia        CHAR(1);                -- cadena vacia
	DECLARE EstatusVigente      CHAR(1);                -- Credito vigente
	DECLARE EstatusInactivo     CHAR(1);                -- Credito Vencido
	DECLARE ConstanteNo         CHAR(1);                -- Constamnte no
	DECLARE CreditoIndividual   INT(11);                -- Credito Individual
	DECLARE CreditoGrupal       INT(11);                -- Credito GRupal
	DECLARE ImprimePagare       INT(11);                -- numero de actualizacion para imprimir pagare de credito
	DECLARE AutorizaCredWS      INT(11);                -- numero de actualizacion para actualizacion de credito
	DECLARE EstatusCerrado      CHAR(1);                -- EStatus cerrado
	DECLARE EstatusActivo       CHAR(1);                -- EStatus activo
	DECLARE GrabaPagare			INT(11);				-- graba pagare
	DECLARE AutorizaCredGrupal 	INT(11);				-- ACTUALIZACION EN CREDITOS ACT GRUPALES
	DECLARE AutorizaCredito		INT(11);				-- actualizacion
	DECLARE DesembolsoCredito	INT(11);				-- Desembolso
	DECLARE Act_Desembolso		INT(11);				-- Numero de actualizacion desembolso
	DECLARE Fecha_Real			CHAR(1);				-- Fecha real de ministracion
	DECLARE Fecha_Pactada		CHAR(1);				-- Fecha Pactada
	DECLARE Var_CreditoMinistra	INT(11);				-- Numero de credito ministra que tiene una fecha menor a la del sistema

	-- Asignacion de constantes
	SET Act_Desembolso		:= 1;
	SET AutorizaCredGrupal  := 12;
	SET AutorizaCredito		:= 3;
	SET Cadena_Vacia		:= '';
	SET ConstanteNo         := 'N';
	SET CreditoGrupal       := 2;
	SET CreditoIndividual   := 1;
	SET Decimal_Cero        := 0.00;
	SET DesembolsoCredito	:= 4;
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
	SET EstatusActivo		:= 'A';
	SET EstatusCerrado		:= 'C';
	SET EstatusInactivo		:= 'I';
	SET EstatusVigente		:= 'V';
	SET Fecha_Pactada		:= 'P';
	SET Fecha_Real			:= 'R';
	SET Fecha_Vacia			:= '1900-01-01';
	SET GrabaPagare			:= 1;
	SET ImprimePagare		:= 2;
	SET Salida_SI			:= 'S';

    ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
				concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-CREDITOSGRUPOSAGROPRO');
			SET Var_Control := 'sqlexception';
		END;

        -- Asignamos valor a varibles
        SET Aud_FechaActual     := NOW();
        SET Var_FechaSis        := (SELECT IFNULL(FechaSistema,Fecha_Vacia) FROM PARAMETROSSIS
                                    WHERE EmpresaID = Par_EmpresaID);
        SET Var_Poliza          := Par_PolizaID;
        SET Var_Consecutivo     := Entero_Cero;

		SELECT GrupoID INTO Var_GrupoID
			FROM GRUPOSCREDITO
		WHERE GrupoID = Par_GrupoID;

		IF(IFNULL(Var_GrupoID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El Numero de Grupo No Existe.';
            SET Var_Control:= 'grupoID';
			LEAVE ManejoErrores;
		END IF;

		SET Var_CreditoMinistra := (SELECT	MINIS.CreditoID
										FROM INTEGRAGRUPOSCRE INTE
										INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = INTE.SolicitudCreditoID
										INNER JOIN CREDITOS CRE ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID
										INNER JOIN MINISTRACREDAGRO AS MINIS ON CRE.CreditoID = MINIS.CreditoID
										WHERE INTE.GrupoID	= Par_GrupoID
										AND INTE.Estatus  IN('A','I')
										AND MINIS.FechaPagoMinis < Var_FechaSis LIMIT 1);
		SET Var_CreditoMinistra	:= IFNULL(Var_CreditoMinistra, Entero_Cero);

		IF (Var_CreditoMinistra != Entero_Cero) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := CONCAT('La Fecha de Ministracion del Credito ',Var_CreditoMinistra,' es Menor a la del Sistema.');
			SET Var_Control:= 'grupoID';
			LEAVE ManejoErrores;
		END IF;

		SET @Var_ConsecutivoID= Entero_Cero;

        IF(Par_TipoActualiza<>DesembolsoCredito)THEN
			-- Se inserta tabla con los valores de cada miembro del grupo en tabla temporal
			INSERT INTO TMPCREDITOSGRUPALESAGRO(
				CreditoGrupID,										CreditoID,			GrupoID,				ProductoCred,					FechaInicio,
				Estatus,											TipoPrepago,		EmpresaID,				Usuario,						FechaActual,
				DireccionIP,										ProgramaID,			Sucursal,				NumTransaccion)
				SELECT
					(@Var_ConsecutivoID:=@Var_ConsecutivoID+1),		Cre.CreditoID,		Inte.GrupoID,			Cre.ProductoCreditoID,			Cre.FechaInicio,
						Cre.Estatus, 		Cre.TipoPrepago,	Par_EmpresaID,      	Aud_Usuario,   				Aud_FechaActual,
						Aud_DireccionIP,    Aud_ProgramaID,    	Aud_Sucursal,       	Aud_NumTransaccion
					FROM INTEGRAGRUPOSCRE Inte,  SOLICITUDCREDITO Sol,  CREDITOS Cre
						WHERE Inte.GrupoID  = Par_GrupoID
							AND Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
							AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
							AND Inte.Estatus = EstatusActivo
							AND Cre.Estatus = EstatusInactivo;
		ELSE
			-- Se inserta tabla con los valores de cada miembro del grupo en tabla temporal
			INSERT INTO TMPCREDITOSGRUPALESAGRO(
				CreditoGrupID,										CreditoID,			GrupoID,				ProductoCred,					FechaInicio,
				Estatus,											TipoPrepago,		EmpresaID,				Usuario,						FechaActual,
				DireccionIP,										ProgramaID,			Sucursal,				NumTransaccion)
				SELECT
				(@Var_ConsecutivoID:=@Var_ConsecutivoID+1),			Cre.CreditoID,		Inte.GrupoID,			Cre.ProductoCreditoID,			Cre.FechaInicio,
				Cre.Estatus, 										Cre.TipoPrepago,	Par_EmpresaID,			Aud_Usuario,					Aud_FechaActual,
				Aud_DireccionIP,    Aud_ProgramaID,					Aud_Sucursal,		Aud_NumTransaccion
				FROM INTEGRAGRUPOSCRE Inte,   SOLICITUDCREDITO Sol,  CREDITOS Cre
					WHERE Inte.GrupoID  = Par_GrupoID
						AND Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
						AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
						AND Inte.Estatus = EstatusActivo
						AND Cre.Estatus = EstatusActivo;
		END IF;

		SET Var_NumIntegrantes := (SELECT COUNT(CreditoGrupID) FROM  TMPCREDITOSGRUPALESAGRO WHERE GrupoID = Par_GrupoID AND NumTransaccion = Aud_NumTransaccion );

		/*Proceso 1: Grabar Pagare de los creditos grupales  *************************************************************************************************** */
		IF(Par_TipoActualiza = GrabaPagare)THEN
			-- Se realiza el ciclo para rgrabar el pagare
			WHILE  (Var_NumIntegrantes > Entero_Cero)  DO
				SELECT CreditoID, TipoPrepago INTO Var_CreditoID, Var_TipoPrepago
					FROM TMPCREDITOSGRUPALESAGRO WHERE CreditoGrupID = Var_NumIntegrantes
						AND GrupoID = Par_GrupoID AND NumTransaccion = Aud_NumTransaccion;

				-- se manda a llamar Creditos act para la ministracion
				CALL CREGENAMORTIZAAGROPRO(
					Var_CreditoID,			Par_FechaMinistra,			Par_FechaMinistra,		Var_TipoPrepago,	ConstanteNo,
					Par_NumErr,				Par_ErrMen,					Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				SET Var_CreditoID       := Entero_Cero;
				SET Var_TipoPrepago     := Cadena_Vacia;
				SET Var_NumIntegrantes  := Var_NumIntegrantes - Entero_Uno;
			END WHILE;

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr      := Entero_Cero;
			SET Par_ErrMen      := CONCAT('Pagare(s) del  Grupo: ',Var_GrupoID,' Generado(s) con Exito.');
			SET Var_Consecutivo := Var_GrupoID;
			SET Var_Control     := 'grupoID';
		END IF;
		/*FIN Proceso 1: Grabar Pagare de los creditos grupales  *********************************************************************************************** */


		/*Proceso 2: Imprime Pagare de los creditos grupales  ************************************************************************************************** */
		IF(Par_TipoActualiza = ImprimePagare)THEN
			-- Se realiza el ciclo para rgrabar el pagare
			WHILE  (Var_NumIntegrantes > Entero_Cero)  DO
				SELECT CreditoID INTO Var_CreditoID
					FROM TMPCREDITOSGRUPALESAGRO WHERE CreditoGrupID = Var_NumIntegrantes
						AND GrupoID = Par_GrupoID AND NumTransaccion = Aud_NumTransaccion;
				-- se manda a llamar Creditos act para la ministracion
				CALL CREDITOSACT(
					Var_CreditoID,      Entero_Cero,       	Fecha_Vacia,		Entero_Cero,		ImprimePagare,
                    Fecha_Vacia,		Fecha_Vacia,		Decimal_Cero,		Decimal_Cero,		Entero_Cero,
                    Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,		ConstanteNo,		Par_NumErr,
                    Par_ErrMen,        	Par_EmpresaID,      Aud_Usuario,   		Aud_FechaActual,    Aud_DireccionIP,
                    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				SET Var_CreditoID       := Entero_Cero;
				SET Var_NumIntegrantes  := Var_NumIntegrantes - Entero_Uno;
			END WHILE;

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr      := Entero_Cero;
			SET Par_ErrMen      := CONCAT('Pagare(s) del  Grupo: ',Var_GrupoID,' Generado(s) con Exito.');
			SET Var_Consecutivo := Var_GrupoID;
			SET Var_Control     := 'grupoID';
		END IF;
		/*FIN Proceso 2: Grabar Pagare de los creditos grupales  *********************************************************************************************** */


		/*Proceso 3: Autorizacion del credito  ***************************************************************************************************************** */
		IF(Par_TipoActualiza = AutorizaCredito)THEN
			WHILE  (Var_NumIntegrantes > Entero_Cero)  DO
				SELECT CreditoID,	FechaInicio INTO Var_CreditoID, Var_FechaInicio
					FROM TMPCREDITOSGRUPALESAGRO WHERE CreditoGrupID = Var_NumIntegrantes
						AND GrupoID = Par_GrupoID AND NumTransaccion = Aud_NumTransaccion;

				CALL CREDITOSACT(
				Var_CreditoID,      Entero_Cero,       	Var_FechaInicio,		Aud_Usuario,		AutorizaCredGrupal,
				Fecha_Vacia,		Fecha_Vacia,		Decimal_Cero,			Decimal_Cero,		Entero_Cero,
				Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,			ConstanteNo,		Par_NumErr,
				Par_ErrMen,        	Par_EmpresaID,      Aud_Usuario,   			Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

				SET Var_CreditoID       := Entero_Cero;
				SET Var_NumIntegrantes  := Var_NumIntegrantes - Entero_Uno;
			END WHILE;

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr      := Entero_Cero;
			SET Par_ErrMen      := CONCAT('Credito(s) del  Grupo: ',Var_GrupoID,' Autorizado(s).');
			SET Var_Consecutivo := Var_GrupoID;
			SET Var_Control     := 'grupoID';
		END IF;
		/*Fin Proceso 3: Autorizacion del credito  ************************************************************************************************************* */


		/*Proceso 4: Proceso de Desembolso del Crédito  ******************************************************************************************************** */
		IF(Par_TipoActualiza = DesembolsoCredito) THEN
			WHILE  (Var_NumIntegrantes > Entero_Cero)  DO
				-- Se obtiene fecha de misntracion
				SELECT CreditoID, ProductoCred	INTO Var_CreditoID, Var_ProductoCreditoID
					FROM TMPCREDITOSGRUPALESAGRO WHERE CreditoGrupID = Var_NumIntegrantes
						AND GrupoID = Par_GrupoID AND NumTransaccion = Aud_NumTransaccion;

				-- Se obtienen numero de dias maximos permitidos para desembolsar.
				SELECT DiasMaxMinistraPosterior INTO Var_DiasMaxMinPos	FROM  CALENDARIOMINISTRA	WHERE ProductoCreditoID = Var_ProductoCreditoID;
				SET Var_DiasMaxMinPos:=IFNULL(Var_DiasMaxMinPos,Entero_Cero);

				-- Se actualiza la misntracion como desembolsada
				CALL MINISTRACREDAGROACT(
					Aud_NumTransaccion,		Entero_Uno,			Entero_Cero,		Var_CreditoID,		Entero_Cero,
					Entero_Cero,			Fecha_Vacia,		Decimal_Cero,		Fecha_Vacia,		Cadena_Vacia,
					Aud_Usuario,			Fecha_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Act_Desembolso,
					ConstanteNo,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				-- validacion de tipo Calculo de Intereses
				SELECT FechaPagoMinis INTO Var_FechaMinistracion
					FROM MINISTRACREDAGRO  WHERE CreditoID = Var_CreditoID
						AND Numero= Entero_Uno;

				IF(Var_FechaMinistracion = Var_FechaSis )THEN
					SET Var_CalculoInt := Fecha_Real;
				  ELSE
					-- Se realiza calculo de limite de feha posterior al desembolso
					SET Var_FechaCalculo := FNSUMADIASFECHA(Var_FechaMinistracion,Var_DiasMaxMinPos);

					CALL DIASFESTIVOSCAL(
						Var_FechaCalculo,	Entero_Uno,			Var_FechaFinal,		Var_EsDiaHabil,		Par_EmpresaID,
						Aud_Usuario,   		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
						Aud_NumTransaccion);

					SET Var_FechaCalculo := Var_FechaFinal;
					IF(Var_FechaSis>=Var_FechaMinistracion AND Var_FechaSis <= Var_FechaCalculo)THEN
						SET Var_CalculoInt:= Fecha_Pactada;
					ELSE
						SET Var_CalculoInt:= Fecha_Real;
					END IF;
				END IF;

				-- se manda a llamr al SP que realiza mninistracion
				CALL MINISTRACREAGROPRO(
					Entero_Uno,			Var_CreditoID,		Var_Poliza,			Var_CalculoInt,			Aud_NumTransaccion,
					ConstanteNo,		Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
					Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				SET Var_CreditoID       	:= Entero_Cero;
				SET Var_NumIntegrantes  	:= Var_NumIntegrantes - Entero_Uno;
				SET Var_CalculoInt			:= Cadena_Vacia;
			END WHILE;

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr      := Entero_Cero;
			SET Par_ErrMen      := CONCAT('Credito(s) del  Grupo: ',Var_GrupoID,' Desembolsado(s) Correctamente.');
			SET Var_Consecutivo := Var_GrupoID;
			SET Var_Control     := 'grupoID';
		END IF;
		/*FIN Proceso 4: Proceso de Desembolso del Crédito  **************************************************************************************************** */

		DELETE  FROM TMPCREDITOSGRUPALESAGRO WHERE GrupoID = Par_GrupoID AND NumTransaccion = Aud_NumTransaccion;
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr          AS NumErr,
			Par_ErrMen          AS ErrMen,
			Var_Control         AS control,
			Var_Consecutivo     AS consecutivo;
	END IF;

END TerminaStore$$