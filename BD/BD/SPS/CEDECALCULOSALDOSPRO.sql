-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDECALCULOSALDOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDECALCULOSALDOSPRO`;
DELIMITER $$


CREATE PROCEDURE `CEDECALCULOSALDOSPRO`(
# ============================================================================
# --- SP QUE INSERTA EN LA TABLA SALDOSCEDES LA FOTO DEL CIERRE DE ESTE DIA---
# ============================================================================
	Par_Fecha			DATE,				-- Fecha de calculo

	Par_Salida			CHAR(1),			-- Indica si espera un SELECT de salida
	INOUT Par_NumErr    INT(11),			-- Numero de error
    INOUT Par_ErrMen    VARCHAR(400),		-- Descripcion de error

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control	    VARCHAR(100);  	-- Variable de control

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT(3);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE	Estatus_Vigente		CHAR(2);
	DECLARE	Estatus_Cancelado	CHAR(2);
	DECLARE	Estatus_Pagado		CHAR(2);
	DECLARE Salida_SI			CHAR(1);
    DECLARE NatMovCargo			CHAR(1);

	-- Asignacion de Constantes
	SET	Fecha_Vacia				:= '1900-01-01';			-- Fecha Vacia
	SET Cadena_Vacia      		:= '';						-- Cadena Vacia
	SET	Decimal_Cero			:= 0.00;					-- DECIMAL Cero
	SET	Entero_Cero				:= 0;						-- Entero Cero
	SET	Estatus_Vigente			:= 'N';						-- Estatus de la Inversion: Vigente
	SET	Estatus_Cancelado		:= 'C';						-- Estatus de la Inversion: Cancelado
	SET	Estatus_Pagado			:= 'P';						-- Estatus de la Inversion: Pagado
	SET Salida_SI       		:= 'S';                 	-- Salida si
    SET NatMovCargo				:= 'C';						-- Naturaleza de movimiento: Cargo

    ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion.Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-CEDECALCULOSALDOSPRO');
				SET Var_Control= 'SQLEXCEPTION';
			END;

		DROP TABLE IF EXISTS TMPSALDOSCEDES;

		CREATE TABLE `TMPSALDOSCEDES` (
			`RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			`FechaCorte` 		DATE NOT NULL ,
			`CedeID` 			INT(11) NOT NULL ,
			`TipoCedeID` 		INT(11) NOT NULL,
			`SaldoCapital` 		DECIMAL(16,2) NOT NULL DEFAULT '0.00' ,
			`SaldoIntProvision`	DECIMAL(14,2) NOT NULL DEFAULT '0.00' ,
			`Estatus` 			CHAR(1) NOT NULL,
			`TasaFija` 			DECIMAL(14,4) DEFAULT NULL ,
			`TasaISR` 			DECIMAL(12,4) DEFAULT NULL ,
			`InteresGenerado` 	DECIMAL(12,2) DEFAULT '0.00' ,
			`InteresRecibir` 	DECIMAL(12,2) DEFAULT '0.00',
			`InteresRetener` 	DECIMAL(12,2) DEFAULT '0.00',
			`TasaBase` 			INT(11) DEFAULT NULL,
			`SobreTasa` 		DECIMAL(12,4) DEFAULT '0.0000',
			INDEX (`FechaCorte`,`CedeID`)
		  );

		DROP TABLE IF EXISTS TMPSALDOSPROVCEDES;

		CREATE TABLE `TMPSALDOSPROVCEDES` (
		  `RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
		  `CedeID` INT(11) NOT NULL ,
		  `SaldoIntProv` DECIMAL(14,2) NOT NULL DEFAULT '0.00'
		  );

		INSERT INTO TMPSALDOSCEDES	(
				FechaCorte,					    CedeID,					TipoCedeID,					SaldoCapital,
				SaldoIntProvision,				Estatus,					TasaFija,				TasaISR,					InteresGenerado,
				InteresRecibir,					InteresRetener,				TasaBase,				SobreTasa)
		SELECT Par_Fecha, 			Ced.CedeID,		Ced.TipoCedeID,		Ced.Monto,				Decimal_Cero,
				Ced.Estatus,		Ced.TasaFija,	Ced.TasaISR, 		Ced.InteresGenerado, 	Ced.InteresRecibir,
				Ced.InteresRetener, Ced.TasaBase, 	Ced.SobreTasa
			FROM 	CEDES Ced
			WHERE 	Ced.Estatus 	= Estatus_Vigente -- CEDES VIGENTE
			OR 		(Ced.Estatus 	= Estatus_Pagado	AND Ced.FechaVencimiento >= Par_Fecha) -- CEDES PAGADAS EL DIA DE HOY
			OR 		(Ced.Estatus 	= Estatus_Cancelado -- CEDES CANCELADAS POR UN VENCIMIENTO ANTICIPADO
			AND		Ced.FechaVenAnt = Par_Fecha
			AND 	Ced.FechaInicio != Par_Fecha);

		INSERT INTO TMPSALDOSPROVCEDES ( CedeID,  SaldoIntProv)
			SELECT Sal.CedeID, IFNULL(SUM(Monto),Decimal_Cero)
				FROM 	TMPSALDOSCEDES Sal INNER JOIN CEDESMOV Mov ON Mov.CedeID = Sal.CedeID
				WHERE 	Mov.NatMovimiento 	= NatMovCargo
				AND 	Mov.TipoMovCedeID 	= 100
				AND 	Mov.Fecha			<= Par_Fecha
				GROUP BY Sal.CedeID;


		UPDATE TMPSALDOSCEDES TSal INNER JOIN  TMPSALDOSPROVCEDES TPSal
			ON TSal.CedeID = TPSal.CedeID
			SET TSal.SaldoIntProvision = TPSal.SaldoIntProv;


		INSERT INTO SALDOSCEDES(
			FechaCorte,			CedeID,			TipoCedeID,			SaldoCapital,		SaldoIntProvision,
			Estatus,			TasaFija,		TasaISR, 			InteresGenerado, 	InteresRecibir,
			InteresRetener, 	TasaBase, 		SobreTasa,			EmpresaID,			Usuario,
			FechaActual,		DireccionIP,	ProgramaID,			Sucursal,			NumTransaccion)
		SELECT
			Par_Fecha, 			Ced.CedeID,		Ced.TipoCedeID,		Ced.SaldoCapital,	Ced.SaldoIntProvision,
			Ced.Estatus,		Ced.TasaFija,	Ced.TasaISR, 		Ced.InteresGenerado,Ced.InteresRecibir,
			Ced.InteresRetener, Ced.TasaBase, 	Ced.SobreTasa,		Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			FROM TMPSALDOSCEDES Ced;

		SET Par_NumErr	:=	0;
		SET Par_ErrMen	:=	'Calculo de Saldos Diarios de CEDES Realizados Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control;
	END IF;

END TerminaStore$$
