-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATALOGOSWSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATALOGOSWSLIS`;DELIMITER $$

CREATE PROCEDURE `CATALOGOSWSLIS`(
Par_SP_Name		    varchar(50),

Par_EmpresaID		int,
Aud_Usuario			int,
Aud_FechaActual		DateTime,
Aud_DireccionIP		varchar(15),
Aud_ProgramaID		varchar(50),
Aud_Sucursal		int,
Aud_NumTransaccion	bigint


	)
TerminaStore: BEGIN



DECLARE Var_Sucur        varchar(20);
DECLARE Var_Paises       varchar(40);
DECLARE Var_EntFed       varchar(40);
DECLARE Var_SecGen       varchar(40);
DECLARE Var_ActividadBMX varchar(40);
DECLARE Var_ActividadFR  varchar(40);
DECLARE Var_Promotores   varchar(20);
DECLARE Var_TipDirecc    varchar(40);
DECLARE Var_Municipio    varchar(30);
DECLARE Var_Localidad    varchar(30);
DECLARE Var_Colonia      varchar(20);
DECLARE Var_Socio        varchar(10);
DECLARE Var_TipIdentifi  varchar(30);
DECLARE Var_EstatusA     char(1);
DECLARE Var_Padre        char(1);
DECLARE Var_Sexo         varchar(6);
DECLARE Var_Femenino     varchar(20);
DECLARE Var_Masculino    varchar(20);
DECLARE Cadena_Vacia     varchar(10);
DECLARE Var_Femen        char(1);
DECLARE Var_Mascu        char(1);
DECLARE Var_Destinos     varchar(20);
DECLARE Var_Plazos       varchar(20);


SET Var_Sucur         := 'Sucursales';
SET Var_Paises        := 'Paises';
SET Var_EntFed        := 'EntidadesFederativa';
SET Var_SecGen        := 'SectorGeneral';
SET Var_ActividadBMX  := 'ActividadBMX';
SET Var_ActividadFR   := 'ActividadFR';
SET Var_Promotores    := 'Promotores';
SET Var_TipDirecc     := 'TiposDeDireccion';
SET Var_Municipio     := 'Municipios';
SET Var_Localidad     := 'Localidades';
SET Var_Colonia       := 'Colonias';
SET Var_Socio         := 'Socios';
SET Var_Sexo          := 'Sexo';
SET Var_Destinos      := 'DestinosCreditos';
SET Var_Plazos        := 'CreditosPlazos';
SET Var_EstatusA      := 'A';
SET Var_TipIdentifi   := 'TiposIdentificaciones';
SET Var_Padre         := '';
SET Var_Femenino      := 'Femenino';
SET Var_Masculino     := 'Masculino';
SET Var_Femen         := 'f';
SET Var_Mascu         := 'm';
SET Cadena_Vacia      := '';



IF(Par_SP_Name = Var_Sucur)THEN
SELECT SucursalID as Id_Campo, NombreSucurs as NombreCampo, Var_Padre as Id_Padre
FROM SUCURSALES;
END IF;




IF(Par_SP_Name = Var_Paises)THEN
SELECT PaisID as Id_Campo, Nombre as NombreCampo, Var_Padre as Id_Padre
FROM PAISES;
END IF;


IF(Par_SP_Name = Var_EntFed)THEN
SELECT EstadoID as Id_Campo, Nombre as NombreCampo, Var_Padre as Id_Padre
FROM ESTADOSREPUB;
END IF;



IF(Par_SP_Name = Var_SecGen)THEN
SELECT SectorID as Id_Campo, Descripcion as NombreCampo, Var_Padre as Id_Padre
FROM SECTORES;

END IF;



IF(Par_SP_Name = Var_ActividadBMX)THEN
SELECT ActividadBMXID as Id_Campo, Descripcion as NombreCampo, Var_Padre as Id_Padre
FROM ACTIVIDADESBMX;
END IF;



IF(Par_SP_Name = Var_ActividadFR)THEN

SELECT ActividadFRID as Id_Campo, Descripcion as NombreCampo, ifnull(FamiliaBANXICO,Cadena_Vacia) as Id_Padre
FROM ACTIVIDADESFR ;
END IF;




IF(Par_SP_Name = Var_Promotores)THEN
SELECT PromotorID as Id_Campo, NombrePromotor as NombreCampo, Var_Padre as Id_Padre
FROM PROMOTORES;
END IF;



IF(Par_SP_Name = Var_TipDirecc)THEN
SELECT TipoDireccionID as Id_Campo, Descripcion as NombreCampo, Var_Padre as Id_Padre
FROM TIPOSDIRECCION;
END IF;




IF(Par_SP_Name = Var_Municipio)THEN
SELECT MunicipioID as Id_Campo, Nombre as NombreCampo, EstadoID as Id_Padre
FROM MUNICIPIOSREPUB;
END IF;




IF(Par_SP_Name = Var_Localidad)THEN
SELECT LocalidadID as Id_Campo, NombreLocalidad as NombreCampo, MunicipioID as Id_Padre
FROM LOCALIDADREPUB where EstadoID=20 ;
END IF;




IF(Par_SP_Name = Var_Colonia)THEN
SELECT ColoniaID as Id_Campo, Asentamiento as NombreCampo, MunicipioID as Id_Padre
FROM COLONIASREPUB where EstadoID=20 ;
END IF;




IF(Par_SP_Name = Var_Socio)THEN
SELECT ClienteID as Id_Campo, concat(PrimerNombre," ",SegundoNombre," ",TercerNombre," ",ApellidoPaterno," ",ApellidoMaterno)
        as NombreCampo, Var_Padre as Id_Padre FROM CLIENTES where Estatus = Var_EstatusA;
END IF;





IF(Par_SP_Name = Var_TipIdentifi)THEN
SELECT TipoIdentiID as Id_Campo, Nombre as NombreCampo, Var_Padre as Id_Padre FROM TIPOSIDENTI;
END IF;



IF(Par_SP_Name = Var_Sexo)THEN

SELECT DISTINCT Sexo AS Id_Campo,
CASE Sexo WHEN Var_Femen THEN Var_Femenino
WHEN Var_Mascu THEN Var_Masculino end AS NombreCampo, Var_Padre AS Id_Padre
FROM CLIENTES WHERE Sexo = Var_Femen OR Sexo = Var_Mascu;
END IF;




IF(Par_SP_Name = Var_Destinos)THEN

SELECT DestinoCreID as Id_Campo, Descripcion as NombreCampo, Var_Padre as Id_Padre
FROM DESTINOSCREDITO;
END IF;




IF(Par_SP_Name = Var_Plazos)THEN

SELECT PlazoID as Id_Campo, Descripcion as NombreCampo, Var_Padre as Id_Padre
FROM CREDITOSPLAZOS;
END IF;

END TerminaStore$$