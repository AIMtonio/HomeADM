-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBPAGOCOMCUR
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBPAGOCOMCUR`;
DELIMITER $$


CREATE PROCEDURE `TARDEBPAGOCOMCUR`(

	Par_TipoTarjetaDebID	INT(11),
	Par_FechaCompara		DATE,
	Par_TD_Activada			INT(11),
	Par_TD_Bloqueada		INT(11),
	Par_Estatus_Bloqueado	INT(11),
	Par_FechaSis			DATE,

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
)

TerminaStore:BEGIN


	DECLARE	Var_TarjetaDebID	CHAR(16);
	DECLARE Var_ClienteID		INT(11);
	DECLARE Var_CuentaAhoID		BIGINT(12);
	DECLARE Var_TipoCuentaID	INT(11);
	DECLARE Var_FpagoComAnual	DATE;

    DECLARE Var_FechaActivacion	DATE;
	DECLARE Var_ComisionAnual	DECIMAL(12,2);
	DECLARE Var_FechaSistema	DATE;
	DECLARE Var_CuentaPaga		BIGINT(12);
	DECLARE Var_TarDebPagoComID	INT(11);

    DECLARE Var_MontoIVA		DECIMAL(14,2);
	DECLARE varControl 			VARCHAR(200);
	DECLARE Var_MontoTotal		DECIMAL(12,2);
	DECLARE Var_PolizaID		BIGINT(20);
	DECLARE Var_FechaApl		DATE;

    DECLARE Var_EsHabil			CHAR(1);
	DECLARE Var_MonedaBaseID	INT(11);


	DECLARE Entero_Cero			INT;
	DECLARE Decimal_Cero		DECIMAL;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Estatus_Activo		CHAR(1);

    DECLARE Salida_SI			CHAR(1);
	DECLARE ID_ComAnual			INT(11);
	DECLARE Cons_IVA			DECIMAL(12,2);
	DECLARE TipoCuentaVista		INT(11);
	DECLARE Con_Meses			INT(11);

    DECLARE PagadoSI			CHAR(1);
	DECLARE PagadoNO			CHAR(1);
	DECLARE TD_DesBloqueada		INT(11);
	DECLARE Cons_FormaPago		CHAR(1);
	DECLARE Cons_CajaID			INT(11);

    DECLARE Estatus_Activada	INT(11);
	DECLARE ConceptoCon			INT(11);
	DECLARE DescripcionMov		VARCHAR(100);
	DECLARE TipoMovAhoID		CHAR(4);
	DECLARE AltaEnPolizaSI		CHAR(1);

    DECLARE AltaDetallePolizaSI	CHAR(1);
	DECLARE NatContaCargo		CHAR(1);
	DECLARE Consecutivo			INT;
	DECLARE ConceptoTarDeb		INT;
	DECLARE ConceptoTarDebIVA	INT;

    DECLARE DescripcionMov1		VARCHAR(150);
	DECLARE DescripcionMov2		VARCHAR(150);
	DECLARE SalidaNO			CHAR(1);
	DECLARE NatOperacionCargo	CHAR(1);
	DECLARE conceptoAhorro		INT;

    DECLARE TipoEvenBloqTar		INT;
	DECLARE MotivoBloqueoTar	INT;
	DECLARE DescAdicBloqTar		VARCHAR(60);
	DECLARE TipoEvenActTar		INT;
	DECLARE MotivoActivaTar		INT;

    DECLARE DescAdicActTar		VARCHAR(60);
	DECLARE ProActualiza 		INT;



	DECLARE CURTARJETASDEBITO CURSOR FOR
		SELECT TarjetaDebID, ClienteID, CuentaAhoId, FechaActivacion, FpagoComAnual
			FROM TARJETADEBITO
				WHERE TipoTarjetaDebID = Par_TipoTarjetaDebID
					AND FechaActivacion <= Par_FechaCompara
					AND (Estatus = Par_TD_Activada OR (Estatus = Par_Estatus_Bloqueado AND MotivoBloqueo = Par_TD_Bloqueada));



	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.0;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Estatus_Activo		:= 'A';

	SET Salida_SI			:= 'S';
	SET ID_ComAnual			:= 1;
	SET Con_Meses			:= 6;
	SET PagadoSI			:= 'S';
	SET PagadoNO			:= 'N';

	SET TD_DesBloqueada		:= 14;
	SET Cons_FormaPago		:= 'A';
	SET Cons_CajaID			:= 0;
	SET Estatus_Activada	:= 7;
	SET TipoEvenBloqTar		:= 8;

	SET MotivoBloqueoTar	:= 13;
	SET DescAdicBloqTar		:= 'Bloqueo por No Pago Anualidad';
	SET TipoEvenActTar		:= 7;
	SET MotivoActivaTar		:= 14;
	SET DescAdicActTar		:= 'Pago de Anualidad';

	SET ConceptoCon			:= 301;
	SET DescripcionMov		:= 'COMISION POR ANUALIDAD DE TD';
	SET TipoMovAhoID		:= '208';
	SET AltaEnPolizaSI		:= 'S';
	SET AltaDetallePolizaSI	:= 'S';

	SET NatContaCargo		:= 'C';
	SET Consecutivo			:= 0;
	SET ConceptoTarDeb		:= 5;
	SET ConceptoTarDebIVA	:= 6;
	SET DescripcionMov1		:= 'COMISION POR ANUALIDAD DE TD';

	SET DescripcionMov2		:= 'IVA POR OTROS INGRESOS';
	SET SalidaNO			:= 'N';
	SET NatOperacionCargo	:= 'C';
	SET conceptoAhorro		:= 1;
	SET ProActualiza 		:= 2;

	SET Var_PolizaID		:= 0;

	SET Cons_IVA 	:= IFNULL((SELECT IVA FROM PARAMETROSSIS Sis,
									SUCURSALES Suc
								WHERE Sis.SucursalMatrizID = Suc.SucursalID) , Decimal_Cero);
	SET TipoCuentaVista		:=(SELECT CuentaVista FROM PARAMETROSCAJA);


	SELECT FechaSistema, MonedaBaseID  INTO Var_FechaSistema, Var_MonedaBaseID
			FROM PARAMETROSSIS LIMIT 1;


	SET Par_NumErr		:= 0;
	SET Par_ErrMen		:= '';


	CALL DIASFESTIVOSCAL(
		Par_FechaSis,		Entero_Cero,		 Var_FechaApl,		Var_EsHabil,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	ManejoErrores:BEGIN

		OPEN  CURTARJETASDEBITO;
			BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					DECLARE EXIT HANDLER FOR SQLEXCEPTION
					BEGIN
						SET Par_NumErr = 999;
						SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
								concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-TARDEBPAGOCOMCUR');
						SET varControl = 'sqlException' ;
					END;

				TARJETAACTIVA: LOOP


				 	FETCH CURTARJETASDEBITO  INTO Var_TarjetaDebID, Var_ClienteID, Var_CuentaAhoID,	Var_FechaActivacion,	Var_FpagoComAnual;

							REALIZACOBRO:BEGIN

									IF(IFNULL(Var_FpagoComAnual, Fecha_Vacia) = Fecha_Vacia)THEN
										SET Var_FpagoComAnual := DATE_ADD(IFNULL(Var_FechaActivacion ,Fecha_Vacia), INTERVAL Con_Meses MONTH);
									ELSE
										SET Var_FpagoComAnual := DATE_ADD(Var_FpagoComAnual, INTERVAL 1 YEAR);

										IF(Var_FpagoComAnual > Par_FechaSis) THEN
											LEAVE REALIZACOBRO;
										END IF;
									END IF;


								 SET Var_TipoCuentaID		:= IFNULL((SELECT TipoCuentaID FROM CUENTASAHO WHERE CuentaAhoID = Var_CuentaAhoID),Entero_Cero);



								 SET Var_ComisionAnual		:=  IFNULL((SELECT MontoComision FROM TARDEBESQUEMACOM
																 WHERE TipoTarjetaDebID = Par_TipoTarjetaDebID
																	AND TipoCuentaID = Var_TipoCuentaID
																	AND TarDebComisionID = ID_ComAnual
																	AND Estatus = Estatus_Activo) , Decimal_Cero);

								SET Var_MontoIVA			:=	Var_ComisionAnual * Cons_IVA;
								SET Var_MontoTotal			:= Var_ComisionAnual + Var_MontoIVA;



								SET Var_CuentaPaga	:= IFNULL((SELECT CuentaAhoID
											FROM 	CUENTASAHO
											WHERE TipoCuentaID	 = TipoCuentaVista
												AND Estatus = Estatus_Activo
												AND ClienteID = Var_ClienteID
												AND SaldoDispon >= Var_MontoTotal
											LIMIT 1) , Entero_Cero);

								IF(Var_CuentaPaga = Entero_Cero) THEN
									SET Var_CuentaPaga	:= IFNULL((SELECT CuentaAhoID
											FROM 	CUENTASAHO
											WHERE Estatus = Estatus_Activo
												AND ClienteID = Var_ClienteID
												AND SaldoDispon >= Var_MontoTotal
											LIMIT 1) , Entero_Cero);
								END IF;

								SET Aud_FechaActual := NOW();



								IF(Var_CuentaPaga > Entero_Cero AND Var_MontoTotal > Decimal_Cero) THEN
									UPDATE TARJETADEBITO
										SET FpagoComAnual = Var_FpagoComAnual,
											PagoComAnual  = PagadoSI,

											EmpresaID       = Par_EmpresaID,
											Usuario         = Aud_Usuario,
											FechaActual     = Aud_FechaActual,
											DireccionIP     = Aud_DireccionIP,
											ProgramaID      = Aud_ProgramaID,
											Sucursal        = Aud_Sucursal,
											NumTransaccion  = Aud_NumTransaccion
										WHERE TarjetaDebID = Var_TarjetaDebID;



									CALL CONTAAHORROPRO(
										Var_CuentaPaga,			Var_ClienteID,		Aud_NumTransaccion,	Par_FechaSis,		Var_FechaApl,
										NatOperacionCargo,		Var_MontoTotal,		DescripcionMov,		Var_ClienteID,		TipoMovAhoID,
										Var_MonedaBaseID,		Entero_Cero, 		AltaEnPolizaSI, 	ConceptoCon,		Var_PolizaID,
										AltaDetallePolizaSI, 	conceptoAhorro,		NatContaCargo,		Par_NumErr,			Par_ErrMen,
										Consecutivo, 			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
										Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);




									CALL POLIZATARJETAPRO(
										 Var_PolizaID,		Par_EmpresaID,			Par_FechaSis,		Var_TarjetaDebID,	Var_ClienteID,
										 ConceptoTarDeb,	Var_MonedaBaseID,		Entero_Cero,		Var_ComisionAnual,	DescripcionMov1,
										 Var_CuentaPaga,	Entero_Cero, 			SalidaNO,			Par_NumErr,			Par_ErrMen,
                                         Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
                                         Aud_NumTransaccion);



											IF(Par_NumErr <> Entero_Cero)THEN
												LEAVE ManejoErrores;
											END IF;


									CALL POLIZATARJETAPRO(
										 Var_PolizaID, 		Par_EmpresaID,			Par_FechaSis,		Var_TarjetaDebID,	Var_ClienteID,
										 ConceptoTarDebIVA,	Var_MonedaBaseID,		Entero_Cero,		Var_MontoIVA,		DescripcionMov2,
										 Var_CuentaPaga,	Entero_Cero, 			SalidaNO,			Par_NumErr,			Par_ErrMen,
                                         Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
                                         Aud_NumTransaccion);



											IF(Par_NumErr <> Entero_Cero)THEN
												LEAVE ManejoErrores;
											END IF;

										IF EXISTS(SELECT TarjetaDebID
													FROM 	TARJETADEBITO
													WHERE TarjetaDebID = Var_TarjetaDebID
													AND Estatus		= Par_Estatus_Bloqueado
													AND MotivoBloqueo = Par_TD_Bloqueada) THEN
											UPDATE TARJETADEBITO
												SET MotivoDesbloqueo = TD_DesBloqueada,
													FechaDesbloqueo  = Par_FechaSis,
													Estatus 		  = Estatus_Activada,

													EmpresaID       = Par_EmpresaID,
													Usuario         = Aud_Usuario,
													FechaActual     = Aud_FechaActual,
													DireccionIP     = Aud_DireccionIP,
													ProgramaID      = Aud_ProgramaID,
													Sucursal        = Aud_Sucursal,
													NumTransaccion  = Aud_NumTransaccion
												WHERE TarjetaDebID = Var_TarjetaDebID;


											INSERT INTO BITACORATARDEB (
												`TarjetaDebID`,		`TipoEvenTDID`,		`MotivoBloqID`,		`DescripAdicio`,	`Fecha`,
												`NombreCliente`,	`EmpresaID`,    	`Usuario`,			`FechaActual`,		`DireccionIP`,
												`ProgramaID`,		`Sucursal`,			`NumTransaccion`)
											VALUES (
												Var_TarjetaDebID, 	TipoEvenActTar, 	MotivoActivaTar, 	DescAdicActTar,		Par_FechaSis,
												Cadena_Vacia,		Par_EmpresaID,		Aud_Usuario,  		Aud_FechaActual,	Aud_DireccionIP,
												Aud_ProgramaID,   	Aud_Sucursal, 		Aud_NumTransaccion);

										END IF;


										CALL FOLIOSAPLICAACT('TARDEBPAGOCOM', Var_TarDebPagoComID);
										INSERT INTO TARDEBPAGOCOM (
												TarDebPagoComID,		TarjetaDebID,		ClienteID,			MontoComision,			MontoIVA,
												MontoTotal,				CuentaAhoID,		Fecha,				FormaPago,				CajaID,
												SucursalID,				EmpresaID,			Usuario,			FechaActual,	  		DireccionIP,
                                                ProgramaID,				Sucursal,  			NumTransaccion)
										VALUES	  (
												Var_TarDebPagoComID,	Var_TarjetaDebID,	Var_ClienteID,		Var_ComisionAnual, 		Var_MontoIVA,
												Var_MontoTotal,			Var_CuentaPaga,		Par_FechaSis,		Cons_FormaPago,			Cons_CajaID,
												Aud_Sucursal,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual, 		Aud_DireccionIP,
                                                Aud_ProgramaID,			Aud_Sucursal,	 	Aud_NumTransaccion);



								ELSE
									UPDATE TARJETADEBITO
										SET MotivoBloqueo 	= Par_TD_Bloqueada,
											FechaBloqueo  	= Par_FechaSis,
											PagoComAnual  	= PagadoNO,
											Estatus	   		= Par_Estatus_Bloqueado,

											EmpresaID      	= Par_EmpresaID,
											Usuario         = Aud_Usuario,
											FechaActual     = Aud_FechaActual,
											DireccionIP     = Aud_DireccionIP,
											ProgramaID      = Aud_ProgramaID,
											Sucursal        = Aud_Sucursal,
											NumTransaccion  = Aud_NumTransaccion
										WHERE TarjetaDebID = Var_TarjetaDebID
											AND IFNULL(FPagoComAnual,Fecha_Vacia) >= IFNULL(FechaBloqueo,Fecha_Vacia) ;



									INSERT INTO BITACORATARDEB (
										`TarjetaDebID`,		`TipoEvenTDID`,		`MotivoBloqID`,		`DescripAdicio`,	`Fecha`,
										`NombreCliente`,	`EmpresaID`,    	`Usuario`,			`FechaActual`,		`DireccionIP`,
										`ProgramaID`,		`Sucursal`,			`NumTransaccion`)
									VALUES (
										Var_TarjetaDebID, 	TipoEvenBloqTar, 	MotivoBloqueoTar, 	DescAdicBloqTar,	Par_FechaSis,
										Cadena_Vacia,		Par_EmpresaID,		Aud_Usuario,  		Aud_FechaActual,	Aud_DireccionIP,
										Aud_ProgramaID,   	Aud_Sucursal, 		Aud_NumTransaccion);

								END IF;
						END REALIZACOBRO;
				END LOOP TARJETAACTIVA;
			END;

		CLOSE CURTARJETASDEBITO;


	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
			SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
					Par_ErrMen		 	AS ErrMen,
					varControl		 	AS control,
					Var_TarjetaDebID	AS consecutivo;
	END IF;

END TerminaStore$$