
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTVERIFICASALDOPRO

DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTVERIFICASALDOPRO`;

DELIMITER $$
CREATE PROCEDURE `APORTVERIFICASALDOPRO`(
# ======================================================================================
# PROCESO QUE CANCELA LAS APORTACIONES CON APERTURA POSTERIOR QUE NO FUERON AUTORIZADAS--
# -------------O QUE LA CUENTA NO TIENE SALDO DISPONIBLE------------
# ======================================================================================
	Par_FechaOperacion      DATE,               -- Fecha de Operacion
	Par_Salida              CHAR(1),            -- Indica una salida
	INOUT Par_NumErr        INT(11),            -- Numero de Error
	INOUT Par_ErrMen        VARCHAR(400),       -- Mensaje de error
	/* Parámetros de Auditoría */
	Par_EmpresaID           INT(11),

	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,
	Aud_DireccionIP         VARCHAR(15),
	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),

	Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de variables
    DECLARE Var_CountApor		INT(11);				-- Cantidad de aportaciones almacenadas en la tabla temporal
    DECLARE Var_ContadorCic		INT(11);				-- Contador para el ciclo que recorre las aportaciones
    DECLARE Var_AportID			INT(11);				-- ID de la aportacion
    DECLARE Var_CuentaAho		BIGINT(20);				-- ID de la cuenta de ahrorro ligada a la aportacion
	DECLARE Var_ClienteID		INT(11);				-- ID del cliente de la aportacion
    DECLARE Var_MontoAport		DECIMAL(18,2);			-- Monto de la aportacion
    DECLARE Var_SaldoDispo		DECIMAL(18,2);			-- Saldo disponible en la cuenta
    DECLARE Var_FechaAutoriza	DATE;					-- Fecha en que autoriza
	DECLARE Var_FechaSucursal	DATE;					-- Fecha de la sucursal
	DECLARE Var_Poliza			BIGINT(20);				-- Poliza
    DECLARE Var_Moneda			INT(11);				-- ID del tipo de moneda de la aportacion

	-- Delaracion de Constantes
	DECLARE Salida_SI		CHAR(1);
	DECLARE Salida_NO       CHAR(1);
	DECLARE CancAut         VARCHAR(50);
	DECLARE Estatus_Can     CHAR(1);
	DECLARE Estatus_Alt     CHAR(1);
    DECLARE Cons_AperFP		CHAR(2);
    DECLARE Estatus_Aut		CHAR(1);
    DECLARE Entero_Uno		INT(11);
    DECLARE Entero_Cero		INT(11);
    DECLARE	Cons_NoAut		VARCHAR(50);
    DECLARE	Cons_SaldoInsuf	VARCHAR(50);
	DECLARE Fecha_Vacia 	DATE;
    DECLARE Mov_ApeAport	VARCHAR(4);
	DECLARE Var_ConAltaAport INT(11);
	DECLARE Var_ConAportCapi INT(11);
	DECLARE Con_Capital 	INT(11);
	DECLARE Nat_Cargo		CHAR(1);
	DECLARE AltPoliza_NO	CHAR(1);
	DECLARE Mov_AhorroSI	CHAR(1);
	DECLARE PolAutomatica   CHAR(1);
    DECLARE conceptoMovAPORT INT(11);
	DECLARE desMovAPORT		VARCHAR(50);
    DECLARE Esta_Vigente	CHAR(1);

	-- Asignacion de Constantes
	SET Salida_SI           := 'S';                      -- Salida en Pantalla SI
	SET Salida_NO           := 'N';                      -- Salida en Pantalla NO
	SET CancAut             := 'APORTVERIFICASALDOPRO';  -- Cancelacion Automatica
	SET Estatus_Can         := 'C';                      -- Estatus Cancelada
	SET Estatus_Alt         := 'A';                      -- Estatus Alta
    SET	Cons_AperFP			:= 'FP';					 -- Apertura de aportacion fecha posterior
    SET Estatus_Aut			:= 'L';						 -- Estatus autorizada
    SET Entero_Uno			:= 1;						 -- Constante uno
    SET Entero_Cero			:= 0;						 -- Constante cero
    SET Cons_NoAut			:= 'Aportacion No Autorizada';-- Descripcion para motivo de cancelacion no autorizadas
    SET Cons_SaldoInsuf		:= 'Recursos Insuficientes en la Cuenta';-- Descripcion para motivo de cancelacion recursos insuficientes
	SET Fecha_Vacia			:= '1900-01-01';			 -- Constante Fecha Vacia
	SET Mov_ApeAport		:= '601'; 					 -- APERTURA DE APORTACION TABLA DE TIPOSMOVSAHO
	SET Var_ConAltaAport	:= 900; 					 -- Constante Mov Aports
	SET Var_ConAportCapi	:= 1;						 -- CONCEPTOSAHORRO
	SET Con_Capital 		:= 1; 						 -- Tabla conceptos ap
	SET Nat_Cargo 			:= 'C'; 					 -- naturaleza cargo
	SET AltPoliza_NO		:= 'N'; 					 -- alta de de poliza no
	SET Mov_AhorroSI		:= 'S'; 					 -- movimiento de ahorro si
	SET PolAutomatica   	:= 'A';						 -- Poliza automatica
    SET conceptoMovAPORT 	:= 900;						 -- ID concepto apertura aportacion
	SET desMovAPORT 		:= 'APERTURA DE APORTACION'; -- Descripcion concepto apertura
    SET	Esta_Vigente		:= 'N';						 -- Estatus vigente aportaciones


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-APORTVERIFICASALDOPRO');
			END;

        -- se cancelan aportaciones con apertura fecha posterior, que no se han autorizado
        -- y que la fecha de inicio es igual a la fecha del cierre
		UPDATE APORTACIONES SET
				Estatus         = Estatus_Can,
                MotivoCancela	= Cons_NoAut,
				EmpresaID       = Par_EmpresaID,
				UsuarioID       = Aud_Usuario,
				FechaActual     = Aud_FechaActual,
				DireccionIP     = Aud_DireccionIP,
				ProgramaID      = CancAut,
				Sucursal        = Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion
		WHERE   FechaInicio 	= Par_FechaOperacion
        AND 	AperturaAport	= Cons_AperFP
		AND 	Estatus			= Estatus_Alt;

        -- se limpia la tabla temporal
        TRUNCATE TABLE TMPAPORTAPERTURAFP;

        -- se realiza el INSERT a la tabla temporal de aportaciones autorizadas con apertura en fecha posterior
        -- con fecha de inicio igual a la del cierre
        INSERT INTO TMPAPORTAPERTURAFP (AportacionID, 	ClienteID, 		CuentaAhoID, 		TipoAportacionID,
								MonedaID, 		AperturaAport, 	FechaInicio, 		Monto, 				FechaVencimiento,
                                FechaPago,	 	TasaFija, 		TipoPagoInt, 		DiasPeriodo, 		PagoIntCal,
                                DiasPago, 		PlazoOriginal, 	PagoIntCapitaliza, 	SaldoCta,			EmpresaID,
                                UsuarioID,		FechaActual, 	DireccionIP, 		ProgramaID, 		Sucursal,
                                NumTransaccion)
			SELECT 				AP.AportacionID, 	AP.ClienteID, 		AP.CuentaAhoID, 		AP.TipoAportacionID,
								AP.MonedaID,		AP.AperturaAport, 	AP.FechaInicio, 		AP.Monto, 				AP.FechaVencimiento,
								AP.FechaPago, 		AP.TasaFija,		AP.TipoPagoInt, 		AP.DiasPeriodo, 		AP.PagoIntCal,
								AP.DiasPago,		AP.PlazoOriginal,	AP.PagoIntCapitaliza, 	CTAS.SaldoDispon, 		AP.EmpresaID,
								AP.UsuarioID,		AP.FechaActual,		AP.DireccionIP,			AP.ProgramaID,			AP.Sucursal,
                                AP.NumTransaccion
				FROM APORTACIONES AP
					INNER JOIN CUENTASAHO CTAS ON AP.CuentaAhoID=CTAS.CuentaAhoID AND AP.ClienteID = CTAS.ClienteID
				WHERE  AP.FechaInicio 		= Par_FechaOperacion
				AND    AP.AperturaAport		= Cons_AperFP
				AND    AP.Estatus			= Estatus_Aut;

		SET Var_CountApor 	:= (SELECT COUNT(*) FROM TMPAPORTAPERTURAFP);
        SET Var_CountApor 	:= IFNULL(Var_CountApor,Entero_Cero);

        SET Var_ContadorCic	:= Entero_Uno;

        SET @numAp := (SELECT COUNT(*) FROM TMPAPORTAPERTURAFP WHERE Monto<=SaldoCta);
        SET @numAp := IFNULL(@numAp,Entero_Cero);

        -- Si hay aportaciones que tienen saldo suficiente en la cuenta se genera el encabezado de la poliza
        IF(@numAp > Entero_Cero) THEN
			CALL MAESTROPOLIZASALT(
				Var_Poliza,			Par_EmpresaID,		Par_FechaOperacion, PolAutomatica,     	conceptoMovAPORT,
				desMovAPORT,		Salida_NO,       	Par_NumErr,			Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,   	Aud_NumTransaccion  );
			IF(Par_NumErr != Entero_Cero) THEN /* SI SURGIO UN ERROR SE SALE DEL SP*/
				LEAVE ManejoErrores;
			END IF;
		END IF;

        -- ciclo para recorrer las aportaciones que se almacenaron en la tabla temporal
        WHILE Var_ContadorCic <= Var_CountApor DO

            -- se obtienen datos de la aportacion por medio del consecutivo de la tabla temporal
            SELECT AportacionID, ClienteID, CuentaAhoID,Monto,MonedaID
				INTO Var_AportID,Var_ClienteID,Var_CuentaAho,Var_MontoAport,Var_Moneda
				FROM TMPAPORTAPERTURAFP
                WHERE ConsecutivoID=Var_ContadorCic;

			SET Var_MontoAport := IFNULL(Var_MontoAport,Entero_Cero);

            -- se obtiene el saldo disponible en la cuenta ligada a la aportacion
			SET Var_SaldoDispo := (SELECT SaldoDispon
									FROM CUENTASAHO
									WHERE CuentaAhoID=Var_CuentaAho
									AND ClienteID=Var_ClienteID);
			SET Var_SaldoDispo := IFNULL(Var_SaldoDispo,Entero_Cero);

            -- validacion para comprobar si la cuenta tiene saldo suficiente y realizar los movimientos
            -- contables, de lo contrario se cancela la aportacion.
			IF(Var_MontoAport <= Var_SaldoDispo)THEN

                SELECT FechaSistema
				INTO Var_FechaAutoriza
					FROM PARAMETROSSIS;
				SET Var_FechaAutoriza :=IFNULL(Var_FechaAutoriza,Fecha_Vacia);

                SELECT FechaSucursal INTO Var_FechaSucursal
					FROM SUCURSALES
					WHERE SucursalID = Aud_Sucursal;

				/* SE MANDA A LLAMAR EL SP QUE REALIZA LAS AFECTACIONES CONTABLES */
				CALL CONTAAPORTPRO(
					Var_AportID,		Par_EmpresaID,		Var_FechaSucursal,		Var_MontoAport,		Mov_ApeAport,
					Var_ConAltaAport,	Var_ConAportCapi,	Con_Capital,			Nat_Cargo,			AltPoliza_NO,
					Mov_AhorroSI,		Salida_No,			Var_Poliza,				Par_NumErr,			Par_ErrMen,
					Var_CuentaAho,		Var_ClienteID,		Var_Moneda,				Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);


				 UPDATE APORTACIONES SET
						Estatus 		= Esta_Vigente,
						FechaApertura	= Var_FechaAutoriza,
						SucursalID		= Aud_Sucursal,
						UsuarioID 		= Aud_Usuario,

						EmpresaID 		= Par_EmpresaID,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID		= Aud_ProgramaID,
						Sucursal		= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
				 WHERE	AportacionID	= Var_AportID;

                 -- actualiza el estatus de las amortizaciones a autorizada
                 UPDATE AMORTIZAAPORT SET
						Estatus 		= Esta_Vigente,
						Usuario 		= Aud_Usuario,

						EmpresaID 		= Par_EmpresaID,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID		= Aud_ProgramaID,
						Sucursal		= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
				 WHERE	AportacionID	= Var_AportID;
            ELSE
            -- SI EL SALDO ES INSUFICIENTE SE CANCELA LA APORTACION Y SE ELIMINAN LAS AMORTIZACIONES
				UPDATE APORTACIONES SET
						Estatus         = Estatus_Can,
                        MotivoCancela	= Cons_SaldoInsuf,
						EmpresaID       = Par_EmpresaID,
						UsuarioID       = Aud_Usuario,
						FechaActual     = Aud_FechaActual,
						DireccionIP     = Aud_DireccionIP,
						ProgramaID      = CancAut,
						Sucursal        = Aud_Sucursal,
						NumTransaccion  = Aud_NumTransaccion
				WHERE   AportacionID 	= Var_AportID;

                -- elimina las amortizaciones para la aportacion cancelada.
                 DELETE FROM AMORTIZAAPORT
				 WHERE	AportacionID	= Var_AportID;
            END IF;

            -- incrementa contador
            SET Var_ContadorCic := Var_ContadorCic+Entero_Uno;
        END WHILE;

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Cancelacion de Aport. Fecha Posterior Exitoso.';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$