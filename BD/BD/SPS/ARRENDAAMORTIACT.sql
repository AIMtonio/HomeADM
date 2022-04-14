-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDAAMORTIACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRENDAAMORTIACT`;DELIMITER $$

CREATE PROCEDURE `ARRENDAAMORTIACT`(
# ===============================================================================================
# -- STORED PROCEDURE PARA ACTUALIZAR LOS SALDOS O MONTOS DEL ARRENDAMIENTO
# ===============================================================================================
	Par_ArrendaID			BIGINT(12),			-- ID del arrendamiento
	Par_ArrendaAmortiID		INT(11),			-- ID del arrendamorti
	Par_Monto				DECIMAL(14,2),		-- valor del monto
	Par_ConceptoArrendaID	INT(11),			-- ID del concepto que hace referencia a la tabla ARRTIPMOVCARGOABONO

	Par_NumAct				TINYINT UNSIGNED,	-- Indica el tipo de actualizacion

	Par_Salida				CHAR(1),			-- Indica si el SP genera o no una salida
	INOUT Par_NumErr		INT(11),			-- Parametro de salida que indica el num. de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro de salida que indica el mensaje de eror

	Par_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal			INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE	Var_Control     		VARCHAR(50);		-- Variable de Control
	DECLARE	Var_EstatusArrenda	 	VARCHAR(50);		-- Varaible del estatus del arrendiamiento
	DECLARE	Var_NumConcepto			INT(11);			-- Variable para almacenar el valor del concepto
	DECLARE	Var_DescConcepto		VARCHAR(100);		-- Variable para almacenar la descripcion del concepto
	DECLARE	Var_ColumAmortiAplica	VARCHAR(20);		-- Variable para el nombre de la columna a la cual se aplicara la actualizacion del monto
	DECLARE Var_Saldo				DECIMAL(14,4);		-- Saldo segun el concepto de cargo o abono

	-- Declaracion de constantes
	DECLARE	Var_NomTabla			VARCHAR(20);		-- Nombre de la tabla a la cual se aplicara la actualizacion
	DECLARE	Entero_Cero				INT(11);			-- Entero cero
	DECLARE Cadena_Vacia			CHAR(1);			-- Cadena vacia
	DECLARE	Salida_Si				CHAR(1);			-- Indica que si se devuelve un mensaje de salida
	DECLARE	Salida_No				CHAR(1);			-- Indica que no se devuelve un mensaje de salida
	DECLARE	Est_Vigente				CHAR(1);			-- Estatus vigente 'V'
	DECLARE	Act_Montos				INT(11);			-- Actualizacion de los montos de un arrendamiento
	DECLARE	Est_Vencida				CHAR(1);			-- Estatus Vencido 'B'
	DECLARE	Est_Atrasada			CHAR(1);			-- Estatus Atrasado 'A'


	-- Asignacion de constantes
	SET	Entero_Cero				:= 0;					-- Entero cero
	SET Cadena_Vacia 			:= ''; 					-- Cadena Vacia
	SET	Salida_Si				:= 'S';					-- El SP si genera una salida
	SET	Salida_No				:= 'N';					-- El SP no genera una salida
	SET Est_Vigente				:= 'V';					-- Estado vigente = V
	SET	Var_NomTabla			:= 'ARRENDAAMORTI';		-- Asignacion al nombre de la tabla a la cual se aplicara la actualizacion
	SET Act_Montos				:= 1;					-- Actualizacion 1 para cambiar los montos del arrendamiento
	SET Est_Vencida				:= 'B';					-- Estado Vencido = B
	SET Est_Atrasada			:= 'A';					-- Estado Atrasado = A

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET	Par_NumErr	:= 999;
				SET	Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. REF: SP-ARRENDAAMORTIACT');
				SET	Var_Control	:= 'SQLEXCEPTION';
			END;

		-- Actualizar saldos y montos de producto
		IF(Par_NumAct = Act_Montos) THEN

			SET	Par_ArrendaID			:= IFNULL(Par_ArrendaID, Entero_Cero);
			SET	Par_ArrendaAmortiID		:= IFNULL(Par_ArrendaAmortiID, Entero_Cero);
			SET	Par_ConceptoArrendaID	:= IFNULL(Par_ConceptoArrendaID, Entero_Cero);

			IF(Par_ArrendaID = Entero_Cero) THEN
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen	:= 'No se especifico el numero de arrendamiento';
				SET Var_Control := 'Par_ArrendaID';
				LEAVE ManejoErrores;
			END IF;

			IF(NOT EXISTS(	SELECT ArrendaID
								FROM ARRENDAMIENTOS
								WHERE ArrendaID = Par_ArrendaID)) THEN
				SET Par_NumErr		:= 002;
				SET Par_ErrMen		:= CONCAT('El arrendamiento[',Par_ArrendaID,'] no existe en ARRENDAMIENTOS');
				SET Var_Control		:= 'Par_ArrendaID';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ArrendaAmortiID = Entero_Cero) THEN
				SET	Par_NumErr 	:= 003;
				SET	Par_ErrMen	:= 'No se especifico el numero de cuota';
				SET Var_Control := 'Par_ArrendaID';
				LEAVE ManejoErrores;
			END IF;

			IF(	(	SELECT COUNT(ArrendaAmortiID)
						FROM ARRENDAAMORTI
						WHERE ArrendaID = Par_ArrendaID
						  AND ArrendaAmortiID = Par_ArrendaAmortiID) = Entero_Cero) THEN
				SET Par_NumErr		:= 004;
				SET Par_ErrMen		:= CONCAT('El numero de cuota[',Par_ArrendaAmortiID,'] para el arrendamiento [',Par_ArrendaID,'] no existe en ARRENDAAMORTI');
				SET Var_Control		:= 'Par_ArrendaAmortiID';
				LEAVE ManejoErrores;
			END IF;


			SET Var_EstatusArrenda := IFNULL((SELECT Estatus
											FROM ARRENDAAMORTI
											WHERE ArrendaAmortiID = Par_ArrendaAmortiID
											  AND ArrendaID = Par_ArrendaID
											  AND Estatus IN (Est_Vigente,Est_Vencida, Est_Atrasada)),Cadena_Vacia);

			IF(Var_EstatusArrenda	= Cadena_Vacia)THEN
				SET Par_NumErr		:= 005;
				SET Par_ErrMen		:= CONCAT('El estatus de la cuota[',Par_ArrendaAmortiID,'] no es valido para realizar Cargos o Abonos');
				SET Var_Control		:= 'Var_EstatusArrenda';
				LEAVE ManejoErrores;
			END IF;


			IF(Par_ConceptoArrendaID = Entero_Cero) THEN
				SET	Par_NumErr 	:= 006;
				SET	Par_ErrMen	:= 'No se especifico el numero de concepto';
				SET Var_Control := 'ConceptoArrendaID';
				LEAVE ManejoErrores;
			END IF;

			IF(NOT EXISTS(	SELECT ConceptoArrendaID
								FROM CONCEPTOSARRENDA
								WHERE ConceptoArrendaID = Par_ConceptoArrendaID)) THEN
				SET Par_NumErr		:= 007;
				SET Par_ErrMen		:= CONCAT('El numero de concepto[',Par_ConceptoArrendaID,'] no existe en CONCEPTOSARRENDA');
				SET Var_Control		:= 'ConceptoArrendaID';
				LEAVE ManejoErrores;
			END IF;

			IF(NOT EXISTS(	SELECT TipMovCargoAbonoID
								FROM ARRTIPMOVCARGOABONO
								WHERE TipMovCargoAbonoID = Par_ConceptoArrendaID) ) THEN
				SET	Par_NumErr 	:= 008;
				SET	Par_ErrMen	:= CONCAT('El numero de concepto[',Par_ConceptoArrendaID,'] no existe en ARRTIPMOVCARGOABONO');
				SET Var_Control := 'ConceptoArrendaID';
				LEAVE ManejoErrores;
			END IF;


			SELECT 	TipMovCargoAbonoID, 	Descripcion,		ColumArrendaAmorti
			  INTO	Var_NumConcepto,		Var_DescConcepto,	Var_ColumAmortiAplica
			  FROM ARRTIPMOVCARGOABONO
			  WHERE TipMovCargoAbonoID = Par_ConceptoArrendaID;

			SET Var_ColumAmortiAplica	:= IFNULL(Var_ColumAmortiAplica, Cadena_Vacia);

			IF(Var_ColumAmortiAplica = Cadena_Vacia) THEN
				SET	Par_NumErr 	:= 009;
				SET	Par_ErrMen	:= CONCAT('El numero de concepto[',Par_ConceptoArrendaID,'] cuya descripcion es [',Var_DescConcepto,'], no especifica la columna de la tabla de Amortizaciones a afectar');
				SET Var_Control := 'ConceptoArrendaID';
				LEAVE ManejoErrores;
			END IF;

			CALL BUSCACOLUMNATABLAPRO(
				Var_NomTabla,		Var_ColumAmortiAplica,	Salida_No,			Par_NumErr,			Par_ErrMen,
				Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

			-- Se obtiene el Saldo actual segun el tipo de concepto(SaldoSeguro, SaldoSeguroVida y SaldoOtrasComisiones).
			SET @Var_Query	:= CONCAT('SELECT ',Var_ColumAmortiAplica
										,' INTO @Var_Saldo'
										,' FROM ',Var_NomTabla
										,' WHERE ArrendaID	= ',Par_ArrendaID
										,' AND ArrendaAmortiID	= ',Par_ArrendaAmortiID);
			PREPARE	selectColumAmortiArrenda FROM	@Var_Query;
			EXECUTE	selectColumAmortiArrenda;
			DEALLOCATE	PREPARE	selectColumAmortiArrenda;

			SET Var_Saldo	:= @Var_Saldo;
			SET @Var_Saldo	:= 0;

			IF((Var_Saldo + Par_Monto) <0)THEN
				SET	Par_NumErr 	:= 010;
				SET	Par_ErrMen	:= CONCAT('El Monto del Abono no debe superar el Saldo Actual [',Var_Saldo,']');
				SET Var_Control := 'Par_Monto';
				LEAVE ManejoErrores;
			END IF;

			-- Se actualizan saldos segun el concepto de cargo o abono
			SET @Var_Query	:= CONCAT('UPDATE ',Var_NomTabla,' SET ',
									Var_ColumAmortiAplica,'	= ',Var_ColumAmortiAplica,'+',Par_Monto,
                                    ', EmpresaID	= ',Par_EmpresaID
									,', Usuario	= ',Aud_Usuario
									,', FechaActual	= ','"',Aud_FechaActual,'"'
									,', DireccionIP	= ','"',Aud_DireccionIP,'"'
									,', ProgramaID	= ','"',Aud_ProgramaID,'"'
									,', Sucursal	= ',Aud_Sucursal
									,', NumTransaccion	= ',Aud_NumTransaccion
								,' WHERE ArrendaID	= ',Par_ArrendaID
								  ,' AND ArrendaAmortiID	= ',Par_ArrendaAmortiID);

			PREPARE	actColumAmortiArrenda FROM	@Var_Query;
			EXECUTE	actColumAmortiArrenda;
			DEALLOCATE	PREPARE	actColumAmortiArrenda;


			-- El registro se actualizo exitosamente.
			SET	Par_NumErr 	:= 000;
			SET	Par_ErrMen	:= 'Amortizacion actualizada exitosamente';
			SET Var_Control := 'ArrendaID';

		END IF;

	END ManejoErrores; -- Fin del bloque manejo de errores

	IF (Par_Salida = Salida_Si) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control;
	END IF;

END TerminaStore$$