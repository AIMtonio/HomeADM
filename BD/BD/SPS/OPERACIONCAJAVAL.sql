-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPERACIONCAJAVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPERACIONCAJAVAL`;DELIMITER $$

CREATE PROCEDURE `OPERACIONCAJAVAL`(


	Par_SucursalID			INT(11),
	Par_CajaID				INT(11),
	Par_Transaccion			BIGINT(20),
	Par_Poliza				BIGINT(20),

	Par_MontoTotalEntrada	DECIMAL(18,4),
	Par_MontoTotalSalida	DECIMAL(18,4),
	Par_MontoOperacion		DECIMAL(18,4),
	Par_TipoOperacion		INT(11),
	Par_DescripcionMov		VARCHAR(100),
	Par_Denominaciones		VARCHAR(500),


	Par_Salida    			char(1),
	inout	Par_NumErr 		INT,
    inout	Par_ErrMen		VARCHAR(350),

	Aud_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT



)
TerminaStore:BEGIN

DECLARE Var_FechaSistema	DATE;
DECLARE Var_SumaSalidas		DECIMAL(14,2);
DECLARE Var_SumaEntradas	DECIMAL(14,2);
DECLARE Var_SumaEntradasDen	DECIMAL(14,2);
DECLARE Var_SumaSalidasDen	DECIMAL(14,2);

DECLARE Var_CargosPoliza	DECIMAL(14,4);
DECLARE Var_AbonosPoliza	DECIMAL(14,4);
DECLARE Var_SumSalidaEfe	DECIMAL(14,2);
DECLARE Var_SumEntradaEfe	DECIMAL(14,2);
DECLARE Var_ContadorReg		INT;

DECLARE Entero_Cero			INT;
DECLARE Cadena_Vacia		CHAR(1);
DECLARE NaturalezaEntrada	INT(11);
DECLARE NaturalezaSalida	INT(11);
DECLARE Salida_SI			CHAR(1);
DECLARE Decimal_Cero		DECIMAL;
DECLARE SiEsEfectivo		CHAR(1);
DECLARE LimiteDifPoliza		DECIMAL;
DECLARE DescripcionError	VARCHAR(1000);
DECLARE Contador			INT;

SET Entero_Cero				:= 0;
SET Cadena_Vacia			:= '';
SET NaturalezaEntrada		:= 1;
SET NaturalezaSalida		:= 2;
SET Salida_SI				:= 'S';
SET Decimal_Cero			:= 0.0;
SET SiEsEfectivo			:= 'S';
SET LimiteDifPoliza			:=0.01;
SET DescripcionError		:="";

SET Par_NumErr  			:= Entero_Cero;
SET Par_ErrMen  			:= Cadena_Vacia;
SET Var_SumaSalidas			:= Decimal_Cero;
SET Var_SumaEntradas		:= Decimal_Cero;
SET Var_SumaEntradasDen		:= Decimal_Cero;
SET Var_SumaSalidasDen		:= Decimal_Cero;
SET Contador				:= 0;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
									 "estamos trabajando para resolverla. Disculpe las molestias que ",
									 "esto le ocasiona. Ref: SP-OPERACIONCAJAVAL");
		END;



SET Par_NumErr	:= 0;
SET Par_ErrMen	:= 'Operacion Realizada Exitosamente';

SELECT FechaSistema INTO Var_FechaSistema
	FROM PARAMETROSSIS
		LIMIT 1;

	SELECT count(TipoOperacion) INTO Var_ContadorReg
			FROM CAJASMOVS
				WHERE 	Transaccion		=Par_Transaccion
				AND 	SucursalID 		=Par_SucursalID
				AND 	CajaID 			=Par_CajaID	;


	SELECT SUM(case when Tipo.Naturaleza = NaturalezaEntrada THEN Mov.MontoEnFirme
					ELSE  Decimal_Cero
			   END),
		   SUM(case when Tipo.Naturaleza = NaturalezaSalida THEN Mov.MontoEnFirme
					ELSE  Decimal_Cero
			   END ),
		   SUM(case when Tipo.Naturaleza = NaturalezaEntrada AND Tipo.EsEfectivo = SiEsEfectivo  THEN Mov.MontoEnFirme
				ELSE  Decimal_Cero
			END),
		   SUM(case when Tipo.Naturaleza = NaturalezaSalida AND Tipo.EsEfectivo = SiEsEfectivo THEN Mov.MontoEnFirme
				ELSE  Decimal_Cero
			END )

			   INTO Var_SumaEntradas, Var_SumaSalidas ,Var_SumEntradaEfe, Var_SumSalidaEfe
			FROM CAJASMOVS Mov
				INNER JOIN CAJATIPOSOPERA Tipo ON Tipo.Numero=Mov.TipoOperacion
				WHERE 	Mov.Transaccion		=Par_Transaccion
				AND 	Mov.SucursalID 		=Par_SucursalID
				AND 	Mov.CajaID 			=Par_CajaID	;

	SET Var_SumaEntradas 	:= IFNULL(Var_SumaEntradas, Decimal_Cero);
	SET Var_SumaSalidas 	:= IFNULL(Var_SumaSalidas, Decimal_Cero);
	SET Var_SumEntradaEfe	:= IFNULL(Var_SumEntradaEfe, Decimal_Cero);
	SET Var_SumSalidaEfe	:= IFNULL(Var_SumSalidaEfe, Decimal_Cero);


	SELECT	SUM(case when Naturaleza = NaturalezaEntrada THEN Monto
					ELSE Decimal_Cero
				END),
			SUM(case when Naturaleza = NaturalezaSalida THEN Monto
					ELSE  Decimal_Cero
				END )
			INTO Var_SumaEntradasDen, Var_SumaSalidasDen
		FROM DENOMINACIONMOVS
			WHERE SucursalID 	= Par_SucursalID
			AND CajaID 			= Par_CajaID
			AND Transaccion 	= Par_Transaccion;

	SET Var_SumaEntradasDen := IFNULL(Var_SumaEntradasDen, Entero_Cero);
	SET Var_SumaSalidasDen	:= IFNULL(Var_SumaSalidasDen, Entero_Cero);





	IF(Var_SumaEntradas <> Var_SumaSalidas)THEN
		if Var_SumaEntradas=Decimal_Cero THEN
			SET DescripcionError:=concat('1.- La Suma de los Movimientos de Entrada en CAJASMOVS es Cero.');
			SET Par_NumErr:=001;
            LEAVE ManejoErrores;
		ELSE
			if Var_SumaSalidas=Decimal_Cero THEN
				SET DescripcionError:=concat('1.- La Suma de los Movimientos de Salida en CAJASMOVS es Cero.');
				SET Par_NumErr:=002;
                LEAVE ManejoErrores;
			ELSE
				SET DescripcionError:=concat('1.- La Suma de los Movimientos de Entrada y Salida de CAJASMOVS no coinciden.');
				SET Par_NumErr:=003;
                LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

	IF IFNULL(Var_ContadorReg,Entero_Cero) =Entero_Cero THEN
		SET DescripcionError:=concat('1.- No se Registraron los Movimientos de Caja (CAJASMOVS).');
		SET Par_NumErr:=004;
        LEAVE ManejoErrores;
	END IF;


	 IF Par_TipoOperacion <> Entero_Cero THEN
		IF (Var_SumEntradaEfe <> Var_SumaEntradasDen)THEN
			IF Var_SumEntradaEfe < Var_SumaEntradasDen  THEN

					SET DescripcionError := concat('1.-La Suma de Entrada de Efectivo en CAJASMOVS es menor que la suma de las Denominaciones Recibidas.');
					SET Par_NumErr:=005;
                    LEAVE ManejoErrores;

			ELSE
				IF Var_SumaEntradasDen < Var_SumEntradaEfe  THEN

						SET DescripcionError := concat('1.-La Suma de las Denominaciones Recibidas es Menor que la suma de Entradas de Efectivo en CAJASMOVS.');
						SET Par_NumErr:=006;
                        LEAVE ManejoErrores;

				 END IF;
			END IF;
		END IF;
	END IF;


	IF Par_TipoOperacion <> Entero_Cero THEN
		IF (Var_SumSalidaEfe <> Var_SumaSalidasDen)THEN
			IF Var_SumSalidaEfe < Var_SumaSalidasDen  THEN

					SET DescripcionError := concat('1.-La Suma de Salida de Efectivo en CAJASMOVS es menor que la suma de las Denominaciones Recibidas.');
					SET Par_NumErr:=007;
                    LEAVE ManejoErrores;
			ELSE

				IF Var_SumaSalidasDen < Var_SumSalidaEfe  THEN

						SET DescripcionError := concat('1.-La Suma de las Denominaciones Recibidas es Menor que la suma de Salidas de Efectivo en CAJASMOVS.');
						SET Par_NumErr:=008;
						LEAVE ManejoErrores;
				 END IF;
			END IF;
		END IF;
	 END IF;



	SELECT round(sum(Cargos),2), round(sum(Abonos),2) INTO Var_CargosPoliza, Var_AbonosPoliza
		FROM DETALLEPOLIZA
		WHERE PolizaID = Par_Poliza;

	SET	Var_CargosPoliza	:= IFNULL(Var_CargosPoliza,Entero_Cero);
	SET	Var_AbonosPoliza	:= IFNULL(Var_AbonosPoliza,Entero_Cero);


	IF(ABS((Var_CargosPoliza - Var_AbonosPoliza)) > LimiteDifPoliza or (Var_CargosPoliza + Var_AbonosPoliza)=Entero_Cero)THEN
			SET DescripcionError:=CONCAT("-",Var_CargosPoliza,"1.- Poliza Descuadrada ",Var_CargosPoliza,"-",Var_AbonosPoliza);
			SET Par_NumErr:=009;
            LEAVE ManejoErrores;
	END IF;

	SET Aud_FechaActual:=NOW();


END ManejoErrores;

if (Par_Salida = Salida_SI) THEN

	 IF (DescripcionError<>"")THEN
		 SET Par_ErrMen	:= CONCAT("Ha ocurrido un error al registrar la operacion. Por favor intente nuevamente.",DescripcionError);
	END IF;

    SELECT convert(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            '' AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$