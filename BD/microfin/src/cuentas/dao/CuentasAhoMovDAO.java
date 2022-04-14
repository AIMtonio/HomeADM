package cuentas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import javax.sql.DataSource;

import cuentas.bean.CuentasAhoBean;
import cuentas.bean.CuentasAhoMovBean;
import cuentas.bean.ReporteCuentasAhoMovBean;

public class CuentasAhoMovDAO extends BaseDAO {

	public CuentasAhoMovDAO() {
		super();
	}

	
	public List listaPrincipal(CuentasAhoMovBean cuentasAhoMov, int tipoLista) {
		String query = "call CUENTASAHOMOVLIS(?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = { cuentasAhoMov.getCuentaAhoID(),
				cuentasAhoMov.getNatMovimiento(), tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CuentasAhoMovDAO.listaPrincipal",
				parametrosAuditoriaBean.getSucursal(), Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOMOVLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {

				CuentasAhoMovBean cuentasAhoMov = new CuentasAhoMovBean();
				cuentasAhoMov.setNumeroMov(resultSet.getString(1));
				cuentasAhoMov.setFecha(resultSet.getString(2));
				cuentasAhoMov.setNatMovimiento(resultSet.getString(3));
				cuentasAhoMov.setDescripcionMov(resultSet.getString(4));
				cuentasAhoMov.setCantidadMov(resultSet.getString(5));
				return cuentasAhoMov;

			}
		});
		return matches;
	}
	public List reporteExcel(ReporteCuentasAhoMovBean reporteCuentasAhoMovBean, int tipoLista) {
		String query = "call CUENTASAHOMOVREP(?,?,?,?,?,?,?,?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = { 
				((!reporteCuentasAhoMovBean.getFechaInicial().isEmpty())?	reporteCuentasAhoMovBean.getFechaInicial(): "1900-01-01"),
				((!reporteCuentasAhoMovBean.getFechaFinal().isEmpty())?		reporteCuentasAhoMovBean.getFechaFinal(): 	"1900-01-01"),
				((!reporteCuentasAhoMovBean.getMostrar().isEmpty())?		reporteCuentasAhoMovBean.getMostrar(): 		"T"),
				Utileria.convierteEntero((!reporteCuentasAhoMovBean.getTipoCuenta().isEmpty())?		reporteCuentasAhoMovBean.getTipoCuenta(): 	"0"),
				Utileria.convierteEntero((!reporteCuentasAhoMovBean.getSucursal().isEmpty())?		reporteCuentasAhoMovBean.getSucursal(): 	"0"),
				Utileria.convierteEntero((!reporteCuentasAhoMovBean.getMoneda().isEmpty())?			reporteCuentasAhoMovBean.getMoneda(): 		"0"),
				Utileria.convierteEntero((!reporteCuentasAhoMovBean.getPromotor().isEmpty())?		reporteCuentasAhoMovBean.getPromotor(): 	"0"),
				((!reporteCuentasAhoMovBean.getGenero().isEmpty())?			reporteCuentasAhoMovBean.getGenero(): 		""),
				Utileria.convierteEntero((!reporteCuentasAhoMovBean.getEstado().isEmpty())?			reporteCuentasAhoMovBean.getEstado(): 		"0"),
				Utileria.convierteEntero((!reporteCuentasAhoMovBean.getMunicipio().isEmpty())?		reporteCuentasAhoMovBean.getMunicipio(): 	"0"),
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CuentasAhoMovDAO.reporteExcel",
				parametrosAuditoriaBean.getSucursal(), 
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOMOVREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {

				ReporteCuentasAhoMovBean reporteCuentasAhoMovBean = new ReporteCuentasAhoMovBean();
				
				reporteCuentasAhoMovBean.setNombreCliente(resultSet.getString("NombreCliente"));
				reporteCuentasAhoMovBean.setCuenta(resultSet.getString("Cuenta"));
				reporteCuentasAhoMovBean.setEtiqueta(resultSet.getString("Etiqueta"));
				reporteCuentasAhoMovBean.setCargos(resultSet.getString("Cargos"));
				reporteCuentasAhoMovBean.setAbonos(resultSet.getString("Abonos"));
				reporteCuentasAhoMovBean.setFechaUltReti(resultSet.getString("FechaUltReti"));
				reporteCuentasAhoMovBean.setFechaUltDepo(resultSet.getString("FechaUltDepo"));
				reporteCuentasAhoMovBean.setSaldo(resultSet.getString("Saldo"));
				
				return reporteCuentasAhoMovBean;

			}
		});
		return matches;
	}
	// Lista para grid de movimientos en las cuentas de ahorro por mes de fecha de deteccion de operaciones inusuales.
	public List listaMovimientosInu(CuentasAhoMovBean cuentasAhoMov, int tipoLista) {
		String query = "call CUENTASAHOMOVLIS(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = { 
				cuentasAhoMov.getCuentaAhoID(),
				cuentasAhoMov.getMes(),
				cuentasAhoMov.getAnio(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CuentasAhoMovDAO.listaPrincipal",
				parametrosAuditoriaBean.getSucursal(), 
				parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOMOVLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {

				CuentasAhoMovBean cuentasAhoMov = new CuentasAhoMovBean();
				cuentasAhoMov.setFecha(resultSet.getString("Fecha"));
				cuentasAhoMov.setDescripcionMov(resultSet.getString("DescripcionMov"));
				cuentasAhoMov.setTipoMov(resultSet.getString("TipoMovimiento"));
				cuentasAhoMov.setReferenciaMov(resultSet.getString("ReferenciaMov"));
				cuentasAhoMov.setCantidadMov(resultSet.getString("CantidadMov"));
				return cuentasAhoMov;

			}
		});
		return matches;
	}

}
