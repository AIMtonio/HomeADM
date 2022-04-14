-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZAFONDEOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZAFONDEOPRO`;
DELIMITER $$


CREATE PROCEDURE `POLIZAFONDEOPRO`(
	/*SP QUE DA DE ALTA LAS POLIZAS CONTABLES DE FONDEO*/
	Par_Poliza				BIGINT,			-- Numero de poliza al que se le insertara el detalle
	Par_Fecha				DATE,			-- Fecha del detalle de poliza
	Par_PlazoContable		CHAR(1),		-- Plazo Contable: C.- Corto plazo L.- Largo Plazo
	Par_TipoInstitID		INT(11),		-- Corresponde con el campo TipoInstitID de la tabla TIPOSINSTITUCION
	Par_NacionalidadIns		CHAR(1),		-- Especifica la nacionalidad de la institucion, corresponde con la tabla SUBCTANACINSFON

	Par_InstitutFondID		INT(11),		-- Id de institucion de fondeo corresponde con la tabla INSTITUTFONDEO
	Par_ConceptoOpera		INT(11),		-- Concepto de operacion, corresponde con la tabla CONCEPTOSFONDEO
	Par_Instrumento			VARCHAR(20),	-- Instrumento Financiero: Credito, CtaAhorro, NumeroFondeo, etc
	Par_Moneda				INT(11),		-- Moneda o Divisa
	Par_Cargos				DECIMAL(14,4),	-- Monto del Cargo

	Par_Abonos				DECIMAL(14,4),	-- Monto del Abonos
	Par_Descripcion			VARCHAR(100),	-- Descripcion de la Poliza
	Par_Referencia			VARCHAR(50),	-- Referencia de la Poliza
	Par_TipoFiguraJur		CHAR(1),		-- Indica la Figura Juridica del Fondeador: PF, PFAE, PM
	Par_TipoFondeador		CHAR(1),		-- Tipo del Operacion: Inversion(I) o Fondeo(F)

	Par_Salida				CHAR(1),		-- Salida S:Si N:No
INOUT	Par_NumErr			INT(11),		-- Numero de Error
INOUT	Par_ErrMen			VARCHAR(400),	-- Mensaje de Error
	Par_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(12)
)

TerminaStore: BEGIN

	/* DECLARACION DE VARIABLES */
	DECLARE Var_Nomenclatura	VARCHAR(30);		/* Guarda la nomenclatura de la cuenta mayor de fondeo */
	DECLARE Var_CuentaMayor		VARCHAR(4);			/* Guarda la cDETALLEMOVSHISuenta mayor de fondeo */
	DECLARE Var_Cuenta			VARCHAR(50);		/* Guarda el numero de cuenta contable */
	DECLARE Var_SubCuentaPL		CHAR(6);			/* Valor de la Subcuenta Plazo */
	DECLARE Var_SubCuentaTI		CHAR(6);			/* Valor de la subcuenta tipo de institucion */
	DECLARE Var_SubCuentaNC		CHAR(6);			/* Valor de la subcuenta nacionalidad */
	DECLARE Var_SubCuentaIF		CHAR(6);			/* Valor de la subcuenta Institucion de Fondeo */
	DECLARE Var_SubCuentaTC		CHAR(6);			/* Valor de la subcuenta por Tipo de Persona */
	DECLARE Var_CentroCostos	INT(11);			/*  Centro de Costos */
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_SubCuentaTM		CHAR(6);

	/* DECLARACION DE CONSTANTES */
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT;
	DECLARE Cuenta_Vacia		CHAR(12);
	DECLARE Procedimiento		VARCHAR(20);

	DECLARE For_CueMayor		CHAR(3);			/* Formula de Cuenta Mayor*/
	DECLARE For_Plazo			CHAR(3);			/* Formula de Plazo */
	DECLARE For_TipIns			CHAR(3);			/* Formula de Tipo de Institucion */
	DECLARE For_NacIns			CHAR(3);			/* Formula de Nacionalidad de la Institucion */
	DECLARE For_InsFon			CHAR(3);			/* Formula de Institucion de fondeo*/
	DECLARE For_TipCliente		CHAR(3);
	DECLARE For_TipMoneda		CHAR(3);

	DECLARE Salida_NO			CHAR(1);
	DECLARE Var_CortoPlazo		CHAR(1);			/* corto plazo*/
	DECLARE Var_LargoPlazo		CHAR(1);			/* largo  plazo*/
	DECLARE Var_Nacional		CHAR(1);			/* Nacional*/
	DECLARE Var_Extranjera		CHAR(1);			/* Extranjera*/
	DECLARE Per_Fisica			CHAR(1);
	DECLARE Per_Moral			CHAR(1);
	DECLARE Per_ActEmp			CHAR(1);
	DECLARE TipoInstrumentoID	INT(11);
	DECLARE Salida_SI			CHAR(1);			/* Salida Si */

	/* ASIGNACION DE CONSTANTES */
	SET Var_CortoPlazo			:= 'C';						/* CortoPlazo */
	SET Var_LargoPlazo			:= 'L';						/* LargoPlazo */
	SET Var_Nacional			:= 'N';						/* Naciona */
	SET Var_Extranjera			:= 'E';						/* Extranjera */
	SET Salida_NO				:= 'N';						/* Indica que no habra una salida */
	SET Cadena_Vacia			:= '';						/* Cadena vacia */
	SET Fecha_Vacia				:= '1900-01-01';			/* Fecha Vacia */
	SET Entero_Cero				:= 0;						/* Entero en Cero */
	SET Cuenta_Vacia			:= '000000000';				/* Numero de cuenta vacia*/

	SET For_CueMayor			:= '&CM';					/* Formula de Cuenta Mayor*/
	SET For_Plazo				:= '&PL';					/* Formula de Plazo */
	SET For_TipIns				:= '&TI';					/* Formula de Tipo de Institucion */
	SET For_NacIns				:= '&NC';					/* Formula de Nacionalidad de la Institucion */
	SET For_InsFon				:= '&IF';					/* Formula de Institucion de fondeo*/
	SET For_TipCliente			:= '&TC';					/* Formula por Tipo de Cliente */
	SET For_TipMoneda			:= '&TM';
	

	SET Per_Fisica				:= 'F';						/* Persona Fisica */
	SET Per_Moral				:= 'M';						/* Persona Moral */
	SET Per_ActEmp				:= 'A';						/* Persona Fisica con Actividad Empresarial */
	SET Procedimiento			:= 'POLIZAFONDEOPRO';		/*Nombre del SP*/
	SET TipoInstrumentoID		:=12; 						/* Tipo Instrumento FONDEADOR*/
	SET Salida_SI				:= 'S';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-POLIZAFONDEOPRO');
			SET Var_Control := 'sqlException';
		END;

		/* ASIGNACION DE VARIABLES */
		SET Var_CentroCostos		:=  (SELECT CentroCostos
											FROM INSTITUTFONDEO
												WHERE InstitutFondID = Par_InstitutFondID);

		SET Var_CentroCostos		:= IFNULL(Var_CentroCostos, Entero_Cero);

		/* se guardan los valores de la cuenta de mayor */
		SELECT	Nomenclatura, 		Cuenta
		INTO	Var_Nomenclatura,	Var_CuentaMayor
			FROM  CUENTASMAYORFONDEO Ctm
				WHERE Ctm.ConceptoFondID	= Par_ConceptoOpera
					AND Ctm.TipoFondeo  = Par_TipoFondeador;

		/* si los valores son nulos se asigna un vacio */
		SET Var_Nomenclatura	:= IFNULL(Var_Nomenclatura, Cadena_Vacia);
		SET Var_CuentaMayor		:= IFNULL(Var_CuentaMayor, Cadena_Vacia);

		IF(Var_Nomenclatura = Cadena_Vacia) THEN/* si la nomenclatura no tiene valor se asigna la cuenta vacia */
			SET Var_Cuenta := Cuenta_Vacia;
		ELSE
			SET Var_Cuenta	:= Var_Nomenclatura;

			/* si se encuentra la formula de cuenta mayor entonces se reemplaza por el valor que
				le corresponde */
			IF LOCATE(For_CueMayor, Var_Cuenta) > 0 THEN
				SET Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
			END IF;

			/* si se encuentra en la formula la subcuenta plazo se reemplaza por el valor que
				le corresponde */
			IF LOCATE(For_Plazo, Var_Cuenta) > 0 THEN
				IF(Par_PlazoContable = Var_CortoPlazo)THEN
					SELECT	CortoPlazo INTO Var_SubCuentaPL
						FROM  SUBCTAPLAZOFON Sub
						  WHERE Sub.ConceptoFonID	= Par_ConceptoOpera
							AND Sub.TipoFondeo  = Par_TipoFondeador;
				ELSE
					SELECT	LargoPlazo INTO Var_SubCuentaPL
						FROM  SUBCTAPLAZOFON Sub
						  WHERE Sub.ConceptoFonID	= Par_ConceptoOpera
							AND Sub.TipoFondeo  = Par_TipoFondeador;
				END IF;

				SET Var_SubCuentaPL := IFNULL(Var_SubCuentaPL, Cadena_Vacia);

				IF (Var_SubCuentaPL != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_Plazo, Var_SubCuentaPL);
				END IF;
			END IF;

			/* si se encuentra en la formula la subcuenta tipo de institucion  se reemplaza por el valor que
				le corresponde */
			IF LOCATE(For_TipIns, Var_Cuenta) > 0 THEN
				SELECT	SubCuenta INTO Var_SubCuentaTI
					FROM  SUBCTATIPINSFON Sub
					WHERE	Sub.TipoInstitID	= Par_TipoInstitID
					  AND	Sub.ConceptoFonID	= Par_ConceptoOpera
						AND Sub.TipoFondeo  = Par_TipoFondeador;

				SET Var_SubCuentaTI := IFNULL(Var_SubCuentaTI, Cadena_Vacia);

				IF (Var_SubCuentaTI != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipIns, Var_SubCuentaTI);
				END IF;
			END IF;

			IF LOCATE(For_TipCliente, Var_Cuenta) > 0 THEN
				IF Par_TipoFiguraJur = Per_Fisica THEN
					SELECT Fisica INTO Var_SubCuentaTC
						FROM  SUBCTATIPERFON Sub
						WHERE Sub.ConceptoFondID	= Par_ConceptoOpera
							AND Sub.TipoFondeo  = Par_TipoFondeador;

				ELSEIF(Par_TipoFiguraJur = Per_Moral) THEN
					SELECT Moral INTO Var_SubCuentaTC
						FROM  SUBCTATIPERFON Sub
						WHERE Sub.ConceptoFondID	= Par_ConceptoOpera
						AND Sub.TipoFondeo  = Par_TipoFondeador;

				ELSEIF(Par_TipoFiguraJur = Per_ActEmp) THEN
					SELECT FisicaActEmp INTO Var_SubCuentaTC
						FROM  SUBCTATIPERFON Sub
						WHERE Sub.ConceptoFondID	= Par_ConceptoOpera
						AND Sub.TipoFondeo  = Par_TipoFondeador;
				END IF;

				SET Var_SubCuentaTC := IFNULL(Var_SubCuentaTC, Cadena_Vacia);

				IF (Var_SubCuentaTC != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipCliente, Var_SubCuentaTC);
				END IF;
			END IF;

			/* si se encuentra en la formula la subcuenta nacionalidad de institucion  se reemplaza por el valor que
				le corresponde */
			IF LOCATE(For_NacIns, Var_Cuenta) > 0 THEN
				IF(Par_NacionalidadIns = Var_Nacional ) THEN
					SELECT	Nacional INTO Var_SubCuentaNC
						FROM  SUBCTANACINSFON Sub
							WHERE Sub.ConceptoFonID	= Par_ConceptoOpera
								AND Sub.TipoFondeo  = Par_TipoFondeador;
				ELSE
					SELECT	Extranjera INTO Var_SubCuentaNC
						FROM  SUBCTANACINSFON Sub
						  WHERE Sub.ConceptoFonID	= Par_ConceptoOpera
							AND Sub.TipoFondeo  = Par_TipoFondeador;
				END IF;
				SET Var_SubCuentaNC := IFNULL(Var_SubCuentaNC, Cadena_Vacia);
				IF (Var_SubCuentaNC != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_NacIns, Var_SubCuentaNC);
				END IF;
			END IF;

			/* si se encuentra en la formula la subcuenta institucion de fondeo se reemplaza por el valor que
				le corresponde */
			IF LOCATE(For_InsFon, Var_Cuenta) > 0 THEN
				SELECT	SubCuenta INTO Var_SubCuentaIF
					FROM  SUBCTAINSFON Sub
						WHERE	Sub.InstitutFondID	= Par_InstitutFondID
							AND	Sub.ConceptoFonID	= Par_ConceptoOpera
							AND Sub.TipoFondeo  = Par_TipoFondeador;

				SET Var_SubCuentaIF := IFNULL(Var_SubCuentaIF, Cadena_Vacia);
				IF (Var_SubCuentaIF != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_InsFon, Var_SubCuentaIF);
				END IF;
			END IF;
			
			IF LOCATE(For_TipMoneda, Var_Cuenta) > 0 THEN
				SELECT	SubCuenta INTO Var_SubCuentaTM
					FROM  SUBCTAMONFON Sub
						WHERE	Sub.MonedaID	= Par_Moneda
							AND	Sub.ConceptoFonID	= Par_ConceptoOpera
							AND Sub.TipoFondeo  = Par_TipoFondeador;

				SET Var_SubCuentaTM := IFNULL(Var_SubCuentaTM, Cadena_Vacia);
				IF (Var_SubCuentaTM != Cadena_Vacia) THEN
					SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipMoneda, Var_SubCuentaTM);
				END IF;
			END IF;
			
		END IF;

		SET Var_Cuenta = REPLACE(Var_Cuenta, '-', Cadena_Vacia); /* se reemplazan los guiones por vacios */

		/* se hace la llamada al detalle de poliza */
		CALL DETALLEPOLIZASALT (
			Par_EmpresaID,		Par_Poliza,			Par_Fecha, 			Var_CentroCostos,		Var_Cuenta,
			Par_InstitutFondID,	Par_Moneda,			Par_Cargos,			Par_Abonos,				Par_Descripcion,
			Par_Referencia,		Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,			Entero_Cero,
			Cadena_Vacia,		Salida_NO, 			Par_NumErr,			Par_ErrMen,				Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= 'Poliza Agregada Exitosamente.';
		SET Var_Control		:= 'graba';
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Par_Poliza 	AS consecutivo;
	END IF;

END TerminaStore$$
