-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPLDOPEINUSUAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISPLDOPEINUSUAALT`;
DELIMITER $$

CREATE PROCEDURE `HISPLDOPEINUSUAALT`(
	Par_FolioSITI				VARCHAR(15),
	Par_UsuarioSITI				VARCHAR(15),
	Par_NombreArchivo			VARCHAR(45),

	Par_Salida					CHAR(1),
	INOUT Par_NumErr			INT(11),
	INOUT Par_ErrMen			VARCHAR(400),
	Par_EmpresaID				INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN




DECLARE	Var_FechaSistema			DATE;
DECLARE	Var_DiasParaEnviar			INT(11);
DECLARE	Var_PeriodoReporte			INT(11);
DECLARE	Var_OrganoSupervisor		VARCHAR(6);
DECLARE	Var_ClaveCasFim			VARCHAR(6);


DECLARE Cadena_Vacia				CHAR(1);
DECLARE Fecha_Vacia				DATE;
DECLARE Entero_Cero				INT(11);
DECLARE	Str_SI					CHAR(1);
DECLARE	Str_NO					CHAR(1);
DECLARE	EstatusReportarOperacion	INT(11);
DECLARE ClavePersonalInterno		CHAR(2);
DECLARE ClavePersonalExterno		CHAR(2);
DECLARE ClaveSistemaAutomatico		CHAR(2);
DECLARE	ParamVigente				CHAR(1);
DECLARE	ActaConstitutiva			CHAR(1);
DECLARE	RegistroTitularCta			CHAR(2);
DECLARE	TipoRepInusuales			CHAR(1);
DECLARE	InstrumEfectivo			CHAR(2);
DECLARE	TipoEliminaEnviados			INT(11);





SET	Cadena_Vacia				:= '';
SET	Fecha_Vacia				:= '1900-01-01';
SET	Entero_Cero				:= 0;
SET	Str_SI					:= 'S';
SET	Str_NO					:= 'N';
SET	EstatusReportarOperacion	:= 3;
SET	ClavePersonalInterno		:= '1';
SET	ClavePersonalExterno		:= '2';
SET	ClaveSistemaAutomatico		:= '3';
SET	ParamVigente				:= 'V';
SET	ActaConstitutiva			:= 'C';
SET	RegistroTitularCta			:= '00';
SET	TipoRepInusuales			:= '2';
SET	InstrumEfectivo			:= '01';
SET	TipoEliminaEnviados			:= 1;



SET	Par_NumErr	:= 1;
SET	Par_ErrMen	:= Cadena_Vacia;


ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr = 999;
					SET Par_ErrMen = CONCAT("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
										"estamos trabajando para resolverla. Disculpe las molestias que ",
										"esto le ocasiona. Ref: SP-HISPLDOPEINUSUAALT");

				END;

	INSERT INTO HISPLDOPEINUSUA(Fecha,OpeInusualID,	ClaveRegistra,	NombreReg,		CatProcedIntID,
								CatMotivInuID,		FechaDeteccion, SucursalID, 	ClavePersonaInv, 	NomPersonaInv,
								EmpInvolucrado, 	Frecuencia, 	DesFrecuencia, 	DesOperacion, 		Estatus,
								ComentarioOC, 		FechaCierre, 	CreditoID, 		CuentaAhoID,  		TransaccionOpe,
								NaturaOperacion, 	MontoOperacion, MonedaID, 		FolioInterno, 		FolioSITI,
								UsuarioSITI,		NombreArchivo,	TipoOpeCNBV,	FormaPago,			EmpresaID,
								Usuario,			FechaActual,	DireccionIP,	ProgramaID,			Sucursal,
								NumTransaccion)
	SELECT	Fecha,				OpeInusualID,		ClaveRegistra,					LEFT(NombreReg,35) AS NombreReg,			CatProcedIntID,
			CatMotivInuID,		FechaDeteccion,		SucursalID,						ClavePersonaInv,			LEFT(NomPersonaInv,100) AS NomPersonaInv,
			EmpInvolucrado,	Frecuencia,				LEFT(DesFrecuencia,50) AS DesFrecuencia,					LEFT(DesOperacion,300) AS DesOperacion,		Estatus,
			LEFT(ComentarioOC,1500) AS ComentarioOC,FechaCierre,					CreditoID,					CuentaAhoID,			TransaccionOpe,
			NaturaOperacion,	MontoOperacion,		MonedaID,						FolioInterno,				Par_FolioSITI,
			Par_UsuarioSITI,	Par_NombreArchivo,	TipoOpeCNBV,					FormaPago,					Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,				Aud_ProgramaID,				Aud_Sucursal,
			Aud_NumTransaccion
	FROM PLDOPEINUSUALES Inu
	WHERE Inu.Estatus = EstatusReportarOperacion
	    AND Inu.FolioInterno > Entero_Cero;

	SET	Par_NumErr = Entero_Cero;

	CALL PLDOPEINUSUALESBAJ(Entero_Cero,			Entero_Cero,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
							TipoEliminaEnviados,	Str_NO,					Par_NumErr,				Par_ErrMen,				Par_EmpresaID,
							Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
							Aud_NumTransaccion);

	IF(Par_NumErr > Entero_Cero) THEN
		SELECT	'001' AS NumErr,
				Par_ErrMen AS ErrMen,
				'opeInusualID	' AS control,
				Entero_Cero	AS consecutivo;
		LEAVE ManejoErrores;
	END IF;

	SET	Par_NumErr	:= Entero_Cero;
	SET	Par_ErrMen	:= CONCAT("Pase a historico de las operaciones inusuales enviadas en el archivo realizado con exito.");
	IF Par_Salida = Str_SI THEN
		SELECT	'000' AS NumErr,
				Par_ErrMen AS ErrMen,
				'opeInusualID	' AS control,
				Entero_Cero	AS consecutivo;
	END IF;
	LEAVE ManejoErrores;

END ManejoErrores;




END TerminaStore$$