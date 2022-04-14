-- SP TMPAFILIACUENTASCLABELIS

DELIMITER ;

DROP PROCEDURE IF EXISTS TMPAFILIACUENTASCLABELIS;

DELIMITER $$

CREATE PROCEDURE `TMPAFILIACUENTASCLABELIS`(
# =======================================================================
# --- STORE PARA LA LISTA DE AFILIACIONES CUENTAS CLABE PARA PROCESAR ---
# =======================================================================
	Par_Tipo				CHAR(1),			-- Tipo Afiliacion: A = Alta B = Baja
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

	Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
    DECLARE Var_NombreCompleto  	VARCHAR(200);	-- Nombre Completo
    DECLARE Var_NombreInstitucion	VARCHAR(45);	-- Nombre Institucion

	-- Declaracion de Constantes
	DECLARE Entero_Cero    		INT(11);
	DECLARE Cadena_Vacia   	 	CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE ClaveExitosa		CHAR(2);
    DECLARE ValorSI				CHAR(2);

    DECLARE ValorNO				CHAR(2);
    DECLARE TipoAfiliacion		CHAR(1);
	DECLARE TipoAmbas			CHAR(1);
    DECLARE TipoAlta			CHAR(1);
    DECLARE CodigoNoAdmite		CHAR(2);

	DECLARE CodigoIndomiciliado CHAR(2);
    DECLARE CodigoBajaOficina	CHAR(2);
    DECLARE CodigoCuentasBaja	CHAR(2);
    DECLARE CodigoDomiciliaBaja	CHAR(2);

    DECLARE TipoBaja			CHAR(1);
	DECLARE Lis_PorProcesar		INT(11);

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0; 				-- Entero Cero
	SET Cadena_Vacia			:= '';   			-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';  	-- Fecha Vacia
    SET ClaveExitosa			:= '00';			-- Clave Exitosa
    SET ValorSI					:= 'SI';			-- Valor: SI

    SET ValorNO					:= 'NO';			-- Valor: NO
    SET TipoAfiliacion			:= 'F'; 			-- Tipo Codigo: Afiliacion
	SET TipoAmbas				:= 'A'; 			-- Tipo Codigo: Ambas
	SET TipoAlta				:= 'A';				-- Tipo Afiliacion: Alta
	SET CodigoNoAdmite			:= '19';			-- Tipo de Cuenta no Admite Domiciliaciones

    SET CodigoIndomiciliado		:= '20';			-- Indomiciliado
    SET CodigoBajaOficina		:= '23';			-- Baja por oficina
    SET CodigoCuentasBaja		:= '25';			-- Todas las domiciliaciones de la cuenta fueron dadas de baja
    SET CodigoDomiciliaBaja		:= '26';			-- Domiciliación dada de baja

    SET TipoBaja				:= 'B';				-- Tipo Afiliacion: Baja
    SET Lis_PorProcesar			:= 1;				-- Lista de Afiliaciones por Procesar

	-- 1.- Lista de Afiliaciones por Procesar
	IF(Par_NumLis = Lis_PorProcesar)THEN

        IF(Par_Tipo = TipoAlta)THEN
			SELECT
				Tmp.NumAfiliacionID,	Tmp.ClienteID,	Cli.NombreCompleto AS NombreCliente,	Ins.InstitucionID, 	UPPER(Ins.NombreCorto) AS NombreInstitucion,
				Tmp.CuentaClabe,  		IF(Tmp.ClaveAfiliacion = ClaveExitosa,ValorSI,ValorNO) AS Afiliada,
				IF(Tmp.ClaveAfiliacion = ClaveExitosa,Cadena_Vacia,Cat.Descripcion) AS Comentario,
				Tmp.ClaveAfiliacion,	Tmp.Tipo
			FROM TMPAFILIACUENTASCLABE Tmp
			INNER JOIN CLIENTES Cli
			ON Tmp.ClienteID = Cli.ClienteID
			INNER JOIN INSTITUCIONES Ins
			ON Tmp.InstitucionID = Ins.InstitucionID
			INNER JOIN CATCODIGOSAFILIADOM Cat
			ON Tmp.ClaveAfiliacion = Cat.ClaveCodigo
			WHERE Tmp.Tipo = Par_Tipo
            AND Cat.TipoCodigo IN(TipoAfiliacion,TipoAmbas);
		END IF;

		IF(Par_Tipo = TipoBaja)THEN
			SELECT
				Tmp.NumAfiliacionID,	Tmp.ClienteID,	Cli.NombreCompleto AS NombreCliente,	Ins.InstitucionID, 	UPPER(Ins.NombreCorto) AS NombreInstitucion,
				Tmp.CuentaClabe,  		IF(Tmp.ClaveAfiliacion IN(CodigoNoAdmite,CodigoIndomiciliado,CodigoBajaOficina,CodigoCuentasBaja,CodigoDomiciliaBaja), ValorSI,ValorNO) AS Afiliada,
				Cat.Descripcion AS Comentario,Tmp.ClaveAfiliacion,	Tmp.Tipo
			FROM TMPAFILIACUENTASCLABE Tmp
			INNER JOIN CLIENTES Cli
			ON Tmp.ClienteID = Cli.ClienteID
			INNER JOIN INSTITUCIONES Ins
			ON Tmp.InstitucionID = Ins.InstitucionID
			INNER JOIN CATCODIGOSAFILIADOM Cat
			ON Tmp.ClaveAfiliacion = Cat.ClaveCodigo
			WHERE Tmp.Tipo = Par_Tipo
            AND Cat.TipoCodigo IN(TipoAfiliacion,TipoAmbas);
        END IF;

	END IF;


END TerminaStore$$