-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESOMOVSCONCILIAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESOMOVSCONCILIAALT`;DELIMITER $$

CREATE PROCEDURE `TESOMOVSCONCILIAALT`(
	Par_CuentaAhoID 		BIGINT(12),			-- ID Cuenta de Ahorro
	Par_InstitucionID		INT(11),			-- ID Institucion
	Par_FechaCarga 			DATE,				-- Fecha Carga
	Par_FechaOperacion		DATE,				-- Fecha Operacion

	Par_NatMovimiento		CHAR(1),			-- Naturaleza de Movimiento
	Par_MontoMov	 		DECIMAL(14,2),		-- Monto Movimiento
	Par_DescripcionMov		VARCHAR(150),		-- Descripcion de Movimiento
	Par_NumCtaInstit		VARCHAR(20),		-- Numero de Cuenta de la Institucion Bancaria
	Par_ReferenciaMov		VARCHAR(150),		-- Referencia Movimiento

	Aud_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria

	Aud_Sucursal			INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de Auditoria
		)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT;
	DECLARE	Fecha_Vacia			DATE;
	DECLARE NatMovCargo			CHAR(1);
	DECLARE	NatMovAbono			CHAR(1);
	DECLARE	Est_NoConciliado	CHAR(1);

	-- Declaracon de Variables
	DECLARE	consecutivo		BIGINT;

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';				-- Cadena Vacia
	SET	Entero_Cero			:= 0;				-- Entero Cero
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	NatMovCargo			:= 'C';				-- Naturaleza Movimiento: Cargo
	SET	NatMovAbono			:= 'A';				-- Naturaleza Movimiento: Cargo
	SET	Est_NoConciliado	:= 'N';				-- Estatus no Conciliado

	-- Asignacion de Variables
	SET consecutivo	:= 0;

	IF(IFNULL(Par_InstitucionID, Entero_Cero))= Entero_Cero THEN
		SELECT '001' AS NumErr,
			 'El campo Institucion esta vacio' AS ErrMen,
			 'InstitucionID' AS control, Entero_Cero AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	SET consecutivo := (SELECT IFNULL(MAX(FolioCargaID),Entero_Cero)+1 FROM TESOMOVSCONCILIA);
	SET Aud_FechaActual := NOW();

	SET Par_CuentaAhoID:= (SELECT CuentaAhoID
						FROM CUENTASAHOTESO
						WHERE InstitucionID = Par_InstitucionID
						AND NumCtaInstit 	= Par_NumCtaInstit);

	INSERT INTO TESOMOVSCONCILIA (
			FolioCargaID,		CuentaAhoID,		NumeroMov,			InstitucionID,		NumCtaInstit,
			FechaCarga,			FechaOperacion,		NatMovimiento,		MontoMov,			DescripcionMov,
			ReferenciaMov,		Status,				EmpresaID,			Usuario,			FechaActual,
			DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
	VALUES(	consecutivo,		Par_CuentaAhoID,	Entero_Cero,		Par_InstitucionID,	Par_NumCtaInstit,
			Par_FechaCarga,		Par_FechaOperacion,	Par_NatMovimiento,	Par_MontoMov,		Par_DescripcionMov,
			Par_ReferenciaMov,	Est_NoConciliado,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	SELECT '000' AS NumErr,
		  CONCAT("", CONVERT(consecutivo, CHAR))  AS ErrMen,
			 'CuentaAhoID' AS control, consecutivo AS consecutivo;

END TerminaStore$$