package pld.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import pld.bean.ReporteOpeRemesasBean;
import ventanilla.bean.CatalogoRemesasBean;
import herramientas.Constantes;

import general.dao.BaseDAO;

public class ReporteOpeRemesasDAO extends BaseDAO{
	
	public ReporteOpeRemesasDAO(){
		super();
	}

	public List <ReporteOpeRemesasBean> reporteOperaRemeExcel(ReporteOpeRemesasBean reporteOpeRemesasBean){
		try{
		String query = "CALL OPERACIONESREMESASREP(" +
				"?,?,?,?,?,		" +
				"?,				" +
				"?,?,?,?,?,		" +
				"?,?);";
		Object[] parametros = {
				reporteOpeRemesasBean.getFechaInicial(),
				reporteOpeRemesasBean.getFechaFinal(),
				reporteOpeRemesasBean.getEntidadTDE(),
				reporteOpeRemesasBean.getTipoOperacion(),
				reporteOpeRemesasBean.getEstatus(),
				
				reporteOpeRemesasBean.getUmbral(),
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPERACIONESREMESASREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				int count = resultSet.getMetaData().getColumnCount();
				ReporteOpeRemesasBean repOperaRemesasBean = new ReporteOpeRemesasBean();
				repOperaRemesasBean.setNombreEntidad(resultSet.getString("NombreEntidad"));
				repOperaRemesasBean.setNumIdentificacion(resultSet.getString("NumIdentificacion"));
				repOperaRemesasBean.setFechaOperacion(resultSet.getString("FechaOperacion"));
				repOperaRemesasBean.setMontoOperacion(resultSet.getString("MontoOperacion"));
				repOperaRemesasBean.setMoneda(resultSet.getString("Moneda"));
				repOperaRemesasBean.setClienteID(resultSet.getString("ClienteID"));
				repOperaRemesasBean.setApellidoPatBene(resultSet.getString("ApellidoPatBene"));
				repOperaRemesasBean.setApellidoMatBene(resultSet.getString("ApellidoMatBene"));
				repOperaRemesasBean.setNombreBene(resultSet.getString("NombreBene"));
				repOperaRemesasBean.setRazonSocialBene(resultSet.getString("RazonSocialBene"));
				repOperaRemesasBean.setTipoPersonaBene(resultSet.getString("TipoPersonaBene"));
				repOperaRemesasBean.setTipoLiquidacion(resultSet.getString("TipoLiquidacion"));
				repOperaRemesasBean.setFechaLiquidacion(resultSet.getString("FechaLiquidacion"));
				repOperaRemesasBean.setMontoLiquidacion(resultSet.getString("MontoLiquidacion"));
				repOperaRemesasBean.setConceptoPago(resultSet.getString("ConceptoPago"));
				repOperaRemesasBean.setCausaDevolucion(resultSet.getString("CausaDevolucion"));
				repOperaRemesasBean.setMonedaLiquidacion(resultSet.getString("MonedaLiquidacion"));
				repOperaRemesasBean.setCuentaClabe(resultSet.getString("CuentaClabe"));
				repOperaRemesasBean.setApellidoPatRemi(resultSet.getString("ApellidoPatRemi"));
				repOperaRemesasBean.setApellidoMatRemi(resultSet.getString("ApellidoMatRemi"));
				repOperaRemesasBean.setNombreRemi(resultSet.getString("NombreRemi"));
				repOperaRemesasBean.setRazonSocialRemi(resultSet.getString("RazonSocialRemi"));
				repOperaRemesasBean.setTipoPersonaRemi(resultSet.getString("TipoPersonaRemi"));
				repOperaRemesasBean.setEstatusOperacion(resultSet.getString("EstatusOperacion"));
			
				return  repOperaRemesasBean;
			}
		});
		return matches;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return null;
	}

}
