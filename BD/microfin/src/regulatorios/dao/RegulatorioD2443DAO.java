package regulatorios.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import regulatorios.bean.RegulatorioD2443Bean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatorioD2443DAO extends BaseDAO{

	public RegulatorioD2443DAO() {
		super();
	}
	
	public List <RegulatorioD2443Bean> reporteRegulatorioD2443Socap(final RegulatorioD2443Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOD2443REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getPeriodo()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOD2443REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
			RegulatorioD2443Bean beanResponse= new RegulatorioD2443Bean();
			
			beanResponse.setPeriodo(resultSet.getString("Periodo"));
			beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
			beanResponse.setSubreporte(resultSet.getString("Subreporte"));
			beanResponse.setClavePuntoTran(resultSet.getString("ClavePuntoTran"));
			beanResponse.setDenomPuntoTran(resultSet.getString("DenomPuntoTran"));
			beanResponse.setClaveTipoPunto(resultSet.getString("ClaveTipoPunto"));
			beanResponse.setClaveSituacion(resultSet.getString("ClaveSituacion"));
			beanResponse.setFechaSituacion(resultSet.getString("FechaSituacion"));
			beanResponse.setCalle(resultSet.getString("Calle"));
			beanResponse.setNumeroExterior(resultSet.getString("NumeroExterior"));
			beanResponse.setNumeroInterior(resultSet.getString("NumeroInterior"));
			beanResponse.setColonia(resultSet.getString("Colonia"));
			beanResponse.setLocalidad(resultSet.getString("Localidad"));
			beanResponse.setMunicipio(resultSet.getString("Municipio"));
			beanResponse.setEstado(resultSet.getString("Estado"));
			beanResponse.setCodigoPostal(resultSet.getString("CodigoPostal"));
			beanResponse.setLatitud(resultSet.getString("Latitud"));
			beanResponse.setLongitud(resultSet.getString("Longitud"));
			
			return beanResponse ;
			}
		});
		return matches;
	}
	
	
	
	public List <RegulatorioD2443Bean> reporteRegulatorioD2443Sofipo(final RegulatorioD2443Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOD2443REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getPeriodo()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOD2443REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
			RegulatorioD2443Bean beanResponse= new RegulatorioD2443Bean();
			
			beanResponse.setPeriodo(resultSet.getString("Periodo"));
			beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
			beanResponse.setSubreporte(resultSet.getString("Subreporte"));
			beanResponse.setClavePuntoTran(resultSet.getString("ClavePuntoTran"));
			beanResponse.setDenomPuntoTran(resultSet.getString("DenomPuntoTran"));
			beanResponse.setClaveTipoPunto(resultSet.getString("ClaveTipoPunto"));
			beanResponse.setClaveSituacion(resultSet.getString("ClaveSituacion"));
			beanResponse.setFechaSituacion(resultSet.getString("FechaSituacion"));
			beanResponse.setCalle(resultSet.getString("Calle"));
			beanResponse.setNumeroExterior(resultSet.getString("NumeroExterior"));
			beanResponse.setNumeroInterior(resultSet.getString("NumeroInterior"));
			beanResponse.setColonia(resultSet.getString("Colonia"));
			beanResponse.setLocalidad(resultSet.getString("Localidad"));
			beanResponse.setMunicipio(resultSet.getString("Municipio"));
			beanResponse.setEstado(resultSet.getString("Estado"));
			beanResponse.setCodigoPostal(resultSet.getString("CodigoPostal"));
			beanResponse.setLatitud(resultSet.getString("Latitud"));
			beanResponse.setLongitud(resultSet.getString("Longitud"));
			beanResponse.setPais(resultSet.getString("Pais"));
			
			return beanResponse ;
			}
		});
		return matches;
	}
	

	
	public List <RegulatorioD2443Bean> reporteRegulatorioD2443Csv(final RegulatorioD2443Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOD2443REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getPeriodo()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOD2443REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioD2443Bean beanResponse= new RegulatorioD2443Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	

}
