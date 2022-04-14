package pld.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import pld.bean.ReportesSITIBean;
import general.dao.BaseDAO;

public class ReportesSITIDAO extends BaseDAO {
	
	public List listaReporteOpPLD(ReportesSITIBean bean, int tipo) {
		String query = "CALL PLDOPERACIONESCNBVREP(" 
				+ "?,?,?,?,?," 
				+ "?,?,?,?,?,"
				+ "?,?);";
		Object[] parametros = { 
				bean.getFechaInicio(),
				bean.getFechaFinal(),
				bean.getEstatus(),
				bean.getOperaciones(),
				tipo,
				parametrosAuditoriaBean.getEmpresaID(),
				
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ReportesSITIDAO.listaReporteOpPLD",
				parametrosAuditoriaBean.getSucursal(),
				
				parametrosAuditoriaBean.getNumeroTransaccion() };

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL PLDOPERACIONESCNBVREP(  " + Arrays.toString(parametros) + ");");List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ReportesSITIBean bean = new ReportesSITIBean();
				bean.setTipoReporte(resultSet.getString("TipoReporte"));
				bean.setPeriodoReporte(resultSet.getString("PeriodoReporte"));
				bean.setFolio(resultSet.getString("Folio"));
				bean.setClaveOrgSupervisor(resultSet.getString("ClaveOrgSupervisor"));
				bean.setClaveEntCasFim(resultSet.getString("ClaveEntCasFim"));
				bean.setLocalidadSuc(resultSet.getString("LocalidadSuc"));
				bean.setSucursalID(resultSet.getString("Sucursal"));
				bean.setTipoOperacionID(resultSet.getString("TipoOperacionID"));
				bean.setInstrumentMonID(resultSet.getString("InstrumentMonID"));
				bean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				bean.setMonto(resultSet.getString("Monto"));
				bean.setClaveMoneda(resultSet.getString("ClaveMoneda"));
				bean.setFechaOpe(resultSet.getString("FechaOpe"));
				bean.setFechaDeteccion(resultSet.getString("FechaDeteccion"));
				bean.setNacionalidad(resultSet.getString("Nacionalidad"));
				bean.setTipoPersona(resultSet.getString("TipoPersona"));
				bean.setRazonSocial(resultSet.getString("RazonSocial"));
				bean.setNombre(resultSet.getString("Nombre"));
				bean.setApellidoPat(resultSet.getString("ApellidoPat"));
				bean.setApellidoMat(resultSet.getString("ApellidoMat"));
				bean.setRFC(resultSet.getString("RFC"));
				bean.setCURP(resultSet.getString("CURP"));
				bean.setFechaNac(resultSet.getString("FechaNac"));
				bean.setDomicilio(resultSet.getString("Domicilio"));
				bean.setColonia(resultSet.getString("Colonia"));
				bean.setLocalidad(resultSet.getString("Localidad"));
				bean.setTelefono(resultSet.getString("Telefono"));
				bean.setActEconomica(resultSet.getString("ActEconomica"));
				bean.setNomApoderado(resultSet.getString("NomApoderado"));
				bean.setApPatApoderado(resultSet.getString("ApPatApoderado"));
				bean.setApMatApoderado(resultSet.getString("ApMatApoderado"));
				bean.setRFCApoderado(resultSet.getString("RFCApoderado"));
				bean.setCURPApoderado(resultSet.getString("CURPApoderado"));
				bean.setCtaRelacionadoID(resultSet.getString("CtaRelacionadoID"));
				bean.setCuenAhoRelacionado(resultSet.getString("CuenAhoRelacionado"));
				bean.setClaveSujeto(resultSet.getString("ClaveSujeto"));
				bean.setNomTitular(resultSet.getString("NomTitular"));
				bean.setApPatTitular(resultSet.getString("ApPatTitular"));
				bean.setApMatTitular(resultSet.getString("ApMatTitular"));
				bean.setDesOperacion(resultSet.getString("DesOperacion"));
				bean.setRazones(resultSet.getString("Razones"));

				return bean;
			}
		});
		return matches;
	}
}
